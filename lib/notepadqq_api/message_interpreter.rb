class NotepadqqApi
  class MessageInterpreter

    def initialize(messageChannel)
      @messageChannel = messageChannel

      # Hash of event handlers, for example
      # {
      #   1: {
      #     "newWindow": [<callback1>, ..., <callbackn>]
      #   },
      #   ...
      # }
      # Where 1 is an objectId and "newWindow" is an event of that object
      @eventHandlers = {}
    end

    # Assign an event of a particular objectId to a callback
    def registerEventHandler(objectId, event, callback)
      event = event.to_sym

      @eventHandlers[objectId] ||= {}
      @eventHandlers[objectId][event] ||= []

      @eventHandlers[objectId][event].push(callback)
    end

    # Calls a method on the remote object objectId
    def invokeApi(objectId, method, args)
      message = {
        :objectId => objectId,
        :method => method,
        :args => args
      }

      @messageChannel.sendMessage(message)
      reply = @messageChannel.getNextResultMessage

      result = [reply["result"]]
      convertStubs!(result)
      result = result[0]

      # Fixme check for errors in reply["err"]

      return result
    end

    def processMessage(message)
      if message.has_key?("event")
        processEventMessage(message)
      elsif message.has_key?("result")
        # We shouldn't have received it here... ignore it
      end
    end

    private

    # Call the handlers connected to this event
    def processEventMessage(message)
      event = message["event"].to_sym
      objectId = message["objectId"]

      if @eventHandlers[objectId] and @eventHandlers[objectId][event]
        handlers = @eventHandlers[objectId][event]

        args = message["args"]
        convertStubs!(args)

        (handlers.length-1).downto(0).each { |i| 
          handlers[i].call(*args)
        }
      end
    end

    def convertStubs!(dataArray)
      # FIXME Use a stack

      dataArray.map! { |value|
        unless value.nil?
          if value.kind_of?(Array)
            convertStubs!(value)

          elsif value.kind_of?(Hash) and
                value["$__nqq__stub_type"].kind_of?(String) and
                value["id"].kind_of?(Fixnum)

            stubType = value["$__nqq__stub_type"]
            begin
              stub = Object::const_get(Stubs.name + "::" + stubType)
              stub.new(self, value["id"])
            rescue
              puts "Unknown stub: " + stubType
              value
            end

          elsif value.kind_of?(Hash)
            value.each do |key, data|
              tmpArray = [data]
              convertStubs!(tmpArray)
              value[key] = tmpArray[0]
            end

            value

          else
            value
          end
        end
      }
    end

  end
end