require 'nqq_api_layer/message_channel'
require 'nqq_api_layer/message_interpreter'
require 'nqq_api_layer/stubs'

class NqqApiLayer
  
  @@socketPath = ARGV[0]
  @@extensionId = ARGV[1]
  
  @@messageChannel = MessageChannel.new(@@socketPath)
  @@messageInterpreter = MessageInterpreter.new(@@messageChannel)
  
  # Start reading messages and calling event handlers
  def self.runEventLoop
    yield
    
    while true do
      messages = @@messageChannel.getMessages
      messages.each do |msg|
        @@messageInterpreter.processMessage(msg)
      end
    end
    
  end
  
  def self.extensionId
    return @@extensionId
  end
  
  # Returns an instance of Nqq
  def self.nqq
    @@nqq ||= Stubs::Nqq.new(@@messageInterpreter, 1);
    return @@nqq
  end
  
end