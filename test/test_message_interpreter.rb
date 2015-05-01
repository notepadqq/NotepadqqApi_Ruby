require 'test/unit'
require 'notepadqq_api/message_channel'
require 'notepadqq_api/message_interpreter'
require 'notepadqq_api/stubs'

class ChannelStub
  def initialize(socket_path) end
  def send_message(msg) end
  def get_messages(block=true) end
  def get_next_result_message() end
end

class MessageInterpreterTest < Test::Unit::TestCase
  
  def test_invoke_api_simple_return
    channel = ChannelStub.new nil
    def channel.get_next_result_message
      {
        'err' => 0,
        'result' => {"$__nqq__stub_type" => 'Notepadqq', "id" => 7}
      }
    end
    
    interpreter = NotepadqqApi::MessageInterpreter.new channel
    
    retval = interpreter.invoke_api(1, 'example', [])
    assert_equal NotepadqqApi::Stubs::Notepadqq.new(interpreter, 7), retval
  end
  
  def test_invoke_api_array_return
    channel = ChannelStub.new nil
    def channel.get_next_result_message
      {
        'err' => 0,
        'result' => [{"$__nqq__stub_type" => 'Notepadqq', "id" => 7},
                     42,
                     {"$__nqq__stub_type" => 'Editor', "id" => 10}
                    ]
      }
    end
    
    interpreter = NotepadqqApi::MessageInterpreter.new channel
    
    retval = interpreter.invoke_api(1, 'example', [])
    assert_equal [NotepadqqApi::Stubs::Notepadqq.new(interpreter, 7),
                  42,
                  NotepadqqApi::Stubs::Editor.new(interpreter, 10)
                 ], retval
  end
  
end