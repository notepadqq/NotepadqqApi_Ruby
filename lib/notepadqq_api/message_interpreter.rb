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

      if reply["err"] != MessageInterpreterError::ErrorCode::NONE
        error = MessageInterpreterError.new(reply["err"])
        raise error, error.description
      end

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

  class MessageInterpreterError < RuntimeError

    module ErrorCode
        NONE = 0
        INVALID_REQUEST = 1
        INVALID_ARGUMENT_NUMBER = 2
        INVALID_ARGUMENT_TYPE = 3
        OBJECT_DEALLOCATED = 4
        OBJECT_NOT_FOUND = 5
        METHOD_NOT_FOUND = 6
    end

    attr_reader :error_code

    def initialize(error_code)
      @error_code = error_code
    end

    def description
      case @error_code
        when ErrorCode::NONE then "None"
        when ErrorCode::INVALID_REQUEST then "Invalid request"
        when ErrorCode::INVALID_ARGUMENT_NUMBER then "Invalid argument number"
        when ErrorCode::INVALID_ARGUMENT_TYPE then "Invalid argument type"
        when ErrorCode::OBJECT_DEALLOCATED then "Object deallocated"
        when ErrorCode::OBJECT_NOT_FOUND then "Object not found"
        when ErrorCode::METHOD_NOT_FOUND then "Method not found"
        else "Unknown error"
      end
    end

  end

end