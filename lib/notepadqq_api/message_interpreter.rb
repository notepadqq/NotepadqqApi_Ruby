class NotepadqqApi
  class MessageInterpreter

    def initialize(message_channel)
      @message_channel = message_channel

      # Hash of event handlers, for example
      # {
      #   1: {
      #     "newWindow": [<callback1>, ..., <callbackn>]
      #   },
      #   ...
      # }
      # Where 1 is an object_id and "newWindow" is an event of that object
      @event_handlers = {}
    end

    # Assign an event of a particular object_id to a callback
    def register_event_handler(object_id, event, callback)
      event = event.to_sym

      @event_handlers[object_id] ||= {}
      @event_handlers[object_id][event] ||= []

      @event_handlers[object_id][event].push(callback)
    end

    # Calls a method on the remote object object_id
    def invoke_api(object_id, method, args)
      message = {
        :objectId => object_id,
        :method => method,
        :args => args
      }

      @message_channel.send_message(message)
      reply = @message_channel.get_next_result_message

      result = [reply["result"]]
      convert_stubs!(result)
      result = result[0]

      if reply["err"] != MessageInterpreterError::ErrorCode::NONE
        error = MessageInterpreterError.new(reply["err"], reply["errStr"])
        raise error, error.description
      end

      return result
    end

    def process_message(message)
      if message.has_key?("event")
        process_event_message(message)
      elsif message.has_key?("result")
        # We shouldn't have received it here... ignore it
      end
    end

    private

    # Call the handlers connected to this event
    def process_event_message(message)
      event = message["event"].to_sym
      object_id = message["objectId"]

      if @event_handlers[object_id] and @event_handlers[object_id][event]
        handlers = @event_handlers[object_id][event]

        args = message["args"]
        convert_stubs!(args)

        (handlers.length-1).downto(0).each { |i| 
          handlers[i].call(*args)
        }
      end
    end

    def convert_stubs!(data_array)
      # FIXME Use a stack

      data_array.map! { |value|
        unless value.nil?
          if value.kind_of?(Array)
            convert_stubs!(value)

          elsif value.kind_of?(Hash) and
                value["$__nqq__stub_type"].kind_of?(String) and
                value["id"].kind_of?(Fixnum)

            stub_type = value["$__nqq__stub_type"]
            begin
              stub = Object::const_get(Stubs.name + "::" + stub_type)
              stub.new(self, value["id"])
            rescue
              puts "Unknown stub: " + stub_type
              value
            end

          elsif value.kind_of?(Hash)
            value.each do |key, data|
              tmp_array = [data]
              convert_stubs!(tmp_array)
              value[key] = tmp_array[0]
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
    attr_reader :error_string

    def initialize(error_code, error_string)
      @error_code = error_code
      @error_string = error_string
    end

    def description
      str_code =
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

      unless @error_string.nil? || @error_string.empty?
        str_code += ': ' + @error_string
      end

      str_code
    end

  end

end