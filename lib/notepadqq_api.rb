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
  
  # Returns an instance of Notepadqq
  def notepadqq
    @nqq ||= Stubs::Notepadqq.new(@messageInterpreter, NQQ_STUB_ID);
    return @nqq
  end
  
end