class NqqApiLayer
  module Stubs

    class Stub

      def initialize(messageInterpreter, id)
        @messageInterpreter = messageInterpreter
        @id = id
      end

      def on(event, &callback)
        @messageInterpreter.registerEventHandler(@id, event, callback)
      end

      def method_missing(method, *args, &block)  
        return @messageInterpreter.invokeApi(@id, method, args)
      end 

      def ==(other)
        other.class <= Stub && id == other.id
      end

      protected

      def id
        @id
      end

    end

    class Nqq < Stub; end
    class Editor < Stub; end
    class Window < Stub; end
    class MenuItem < Stub; end

  end
end