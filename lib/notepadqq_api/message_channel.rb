require 'socket'
require 'json'

class NotepadqqApi
  class MessageChannel

    def initialize(socketPath)
      # Connect to Notepadqq socket
      @client = UNIXSocket.open(socketPath)

      @incomingBuffer = "" # Incomplete json messages (as strings)
      @parsedBuffer = [] # Unprocessed object messages
    end

    # Sends a JSON message to Notepadqq
    def sendMessage(msg)
      sendRawMessage(JSON.generate(msg))
    end

    # Read incoming messages
    def getMessages(block=true)

      begin
        if block and @incomingBuffer.empty? and @parsedBuffer.empty?
          read = @client.recv(1048576)
        else
          read = @client.recv_nonblock(1048576)
        end
      rescue
        read = ""
      end

      @incomingBuffer += read
      messages = @incomingBuffer.split("\n")

      if @incomingBuffer.end_with? "\n"
        # We only got complete messages: clear the buffer
        @incomingBuffer.clear
      else
        # We need to store the incomplete message in the buffer
        @incomingBuffer = messages.pop || ""
      end

      converted = []
      for i in 0...messages.length
        begin
          msg = JSON.parse(messages[i])
          converted.push(msg)
        rescue
          puts "Invalid message received."
        end
      end

      retval = @parsedBuffer + converted
      @parsedBuffer = []

      # Make sure that, when block=true, at least one message is received
      if block and retval.empty?
        retval += getMessages(true)
      end

      return retval
    end

    # Get the next message of type "result".
    # The other messages will still be returned by getMessages 
    def getNextResultMessage
      discarded = []

      while true do
        chunk = self.getMessages
        for i in 0...chunk.length
          if chunk[i].has_key?("result")
            discarded += chunk[0...i]
            discarded += chunk[i+1..-1]
            @parsedBuffer = discarded
            return chunk[i]
          end
        end

        discarded += chunk
      end

    end

    private

    # Sends a raw string message to Notepadqq
    def sendRawMessage(msg)
      @client.send(msg, 0)
    end

  end
end