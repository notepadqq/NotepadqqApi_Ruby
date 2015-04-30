require 'test/unit'
require 'notepadqq_api/message_channel'
require 'notepadqq_api/message_interpreter'
require 'notepadqq_api/stubs'

class ChannelStub
  def initialize(socketPath) end
  def sendMessage(msg) end
  def getMessages(block=true) end
  def getNextResultMessage() end
end

class MessageInterpreterTest < Test::Unit::TestCase
  
  def test_invokeApi_simple_return
    channel = ChannelStub.new nil
    def channel.getNextResultMessage
      {
        'err' => 0,
        'result' => {"$__nqq__stub_type" => 'Notepadqq', "id" => 7}
      }
    end
    
    interpreter = NotepadqqApi::MessageInterpreter.new channel
    
    retval = interpreter.invokeApi(1, 'example', [])
    assert_equal NotepadqqApi::Stubs::Notepadqq.new(interpreter, 7), retval
  end
  
  def test_invokeApi_array_return
    channel = ChannelStub.new nil
    def channel.getNextResultMessage
      {
        'err' => 0,
        'result' => [{"$__nqq__stub_type" => 'Notepadqq', "id" => 7},
                     42,
                     {"$__nqq__stub_type" => 'Editor', "id" => 10}
                    ]
      }
    end
    
    interpreter = NotepadqqApi::MessageInterpreter.new channel
    
    retval = interpreter.invokeApi(1, 'example', [])
    assert_equal [NotepadqqApi::Stubs::Notepadqq.new(interpreter, 7),
                  42,
                  NotepadqqApi::Stubs::Editor.new(interpreter, 10)
                 ], retval
  end
  
end