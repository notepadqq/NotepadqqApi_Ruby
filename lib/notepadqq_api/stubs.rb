class NotepadqqApi
  module Stubs

    class Stub
      
      def initialize(message_interpreter, id)
        @message_interpreter = message_interpreter
        @id = id
      end

      def on(event, &callback)
        @message_interpreter.register_event_handler(@id, event, callback)
      end

      def method_missing(method, *args, &block)  
        return @message_interpreter.invoke_api(@id, method, args)
      end 

      def ==(other)
        other.class <= Stub &&
        id == other.id &&
        message_interpreter == other.message_interpreter
      end

      protected
      
      attr_reader :id, :message_interpreter

    end

    class Notepadqq < Stub; end
    class Editor < Stub; end
    class Window < Stub; end
    class MenuItem < Stub; end

  end
end