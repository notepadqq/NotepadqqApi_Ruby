require 'notepadqq_api/message_channel'
require 'notepadqq_api/message_interpreter'
require 'notepadqq_api/stubs'

class NotepadqqApi
  
  NQQ_STUB_ID = 1
  private_constant :NQQ_STUB_ID
  
  attr_reader :extension_id
  
  def initialize(socket_path = ARGV[0], extension_id = ARGV[1])
    @socket_path = socket_path
    @extension_id = extension_id
    
    @message_channel = MessageChannel.new(@socket_path)
    @message_interpreter = MessageInterpreter.new(@message_channel)
  end
  
  # Start reading messages and calling event handlers
  def run_event_loop
    yield
    
    while true do
      messages = @message_channel.get_messages
      messages.each do |msg|
        @message_interpreter.process_message(msg)
      end
    end
  end
  
  # For compatibility
  alias_method :runEventLoop, :run_event_loop
  
  # Execute a block for every new window.
  # This is preferable to the "newWindow" event of Notepadqq, because it could
  # happen that the extension isn't ready soon enough to receive the
  # "newWindow" event for the first Window. This method, instead, ensures that
  # the passed block will be called once and only once for each current or
  # future window.
  def on_window_created(&callback)
    captured_windows = []
    
    # Invoke the callback for every currently open window
    notepadqq.windows.each do |window|
      unless captured_windows.include? window
        captured_windows.push window
        callback.call(window)
      end
    end

    # Each time a new window gets opened, invoke the callback.
    # When Notepadqq is starting and initializing all the extensions,
    # we might not be fast enough to receive this event: this is why
    # we manually invoked the callback for every currently open window.
    notepadqq.on(:newWindow) do |window|
      unless captured_windows.include? window
        captured_windows.push window
        callback.call(window)
      end
    end
  end
  
  # For compatibility
  alias_method :onWindowCreated, :on_window_created
  
  # Returns an instance of Notepadqq
  def notepadqq
    @nqq ||= Stubs::Notepadqq.new(@message_interpreter, NQQ_STUB_ID);
    return @nqq
  end
  
end