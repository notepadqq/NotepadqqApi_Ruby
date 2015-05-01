require 'socket'
require 'json'

class NotepadqqApi
  class MessageChannel

    def initialize(socket_path)
      # Connect to Notepadqq socket
      @client = UNIXSocket.open(socket_path)

      @incoming_buffer = "" # Incomplete json messages (as strings)
      @parsed_buffer = [] # Unprocessed object messages
    end

    # Sends a JSON message to Notepadqq
    def send_message(msg)
      send_raw_message(JSON.generate(msg))
    end

    # Read incoming messages
    def get_messages(block=true)

      begin
        if block and @incoming_buffer.empty? and @parsed_buffer.empty?
          read = @client.recv(1048576)
        else
          read = @client.recv_nonblock(1048576)
        end
      rescue
        read = ""
      end

      @incoming_buffer += read
      messages = @incoming_buffer.split("\n")

      if @incoming_buffer.end_with? "\n"
        # We only got complete messages: clear the buffer
        @incoming_buffer.clear
      else
        # We need to store the incomplete message in the buffer
        @incoming_buffer = messages.pop || ""
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

      retval = @parsed_buffer + converted
      @parsed_buffer = []

      # Make sure that, when block=true, at least one message is received
      if block and retval.empty?
        retval += get_messages(true)
      end

      return retval
    end

    # Get the next message of type "result".
    # The other messages will still be returned by get_messages 
    def get_next_result_message
      discarded = []

      while true do
        chunk = self.get_messages
        for i in 0...chunk.length
          if chunk[i].has_key?("result")
            discarded += chunk[0...i]
            discarded += chunk[i+1..-1]
            @parsed_buffer = discarded
            return chunk[i]
          end
        end

        discarded += chunk
      end

    end

    private

    # Sends a raw string message to Notepadqq
    def send_raw_message(msg)
      @client.send(msg, 0)
    end

  end
end