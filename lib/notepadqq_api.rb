require 'notepadqq_api/message_channel'
require 'notepadqq_api/message_interpreter'
require 'notepadqq_api/stubs'

class NotepadqqApi
  
  NQQ_STUB_ID = 1
  
  attr_reader :extensionId
  
  def initialize(socketPath = ARGV[0], extensionId = ARGV[1])
    @socketPath = socketPath
    @extensionId = extensionId
    
    @messageChannel = MessageChannel.new(@socketPath)
    @messageInterpreter = MessageInterpreter.new(@messageChannel)
  end
  
  # Start reading messages and calling event handlers
  def runEventLoop
    yield
    
    while true do
      messages = @messageChannel.getMessages
      messages.each do |msg|
        @messageInterpreter.processMessage(msg)
      end
    end
    
  end
  
  # Execute a block for every new window.
  # This is preferable to the "newWindow" event of Notepadqq, because it could
  # happen that the extension isn't ready soon enough to receive the
  # "newWindow" event for the first Window. This method, instead, ensures that
  # the passed block will be called once and only once for each current or
  # future window.
  def onWindowCreated(&callback)
    capturedWindows = []
    
    # Invoke the callback for every currently open window
    notepadqq.windows.each do |window|
      unless capturedWindows.include? window
        capturedWindows.push window
        callback.call(window)
      end
    end

    # Each time a new window gets opened, invoke the callback.
    # When Notepadqq is starting and initializing all the extensions,
    # we might not be fast enough to receive this event: this is why
    # we manually invoked the callback for every currently open window.
    notepadqq.on(:newWindow) do |window|
      unless capturedWindows.include? window
        capturedWindows.push window
        callback.call(window)
      end
    end
  end
  
  # Returns an instance of Notepadqq
  def notepadqq
    @nqq ||= Stubs::Notepadqq.new(@messageInterpreter, NQQ_STUB_ID);
    return @nqq
  end
  
end