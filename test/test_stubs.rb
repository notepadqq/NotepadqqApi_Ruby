require 'minitest/autorun'
require 'notepadqq_api/stubs'

class StubsTest < Minitest::Test
  
  def test_comparison
    
    # Different class
    
    assert_equal NotepadqqApi::Stubs::Notepadqq.new(nil, 7),
             NotepadqqApi::Stubs::Stub.new(nil, 7)
    
    assert_equal NotepadqqApi::Stubs::Stub.new(nil, 7),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 7)
    
    assert_equal NotepadqqApi::Stubs::Stub.new(nil, 7),
             NotepadqqApi::Stubs::Stub.new(nil, 7)
    
    assert_equal NotepadqqApi::Stubs::Notepadqq.new(nil, 7),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 7)
    
    # Different id
    
    refute_equal NotepadqqApi::Stubs::Notepadqq.new(nil, 1),
             NotepadqqApi::Stubs::Stub.new(nil, 2)
    
    refute_equal NotepadqqApi::Stubs::Stub.new(nil, 1),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 2)
    
    refute_equal NotepadqqApi::Stubs::Stub.new(nil, 1),
             NotepadqqApi::Stubs::Stub.new(nil, 2)
    
    refute_equal NotepadqqApi::Stubs::Notepadqq.new(nil, 1),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 2)
    
    # Different channel
    
    refute_equal NotepadqqApi::Stubs::Notepadqq.new("test", 7),
             NotepadqqApi::Stubs::Stub.new(nil, 7)
    
    refute_equal NotepadqqApi::Stubs::Stub.new("test", 7),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 7)
    
    refute_equal NotepadqqApi::Stubs::Stub.new("test", 7),
             NotepadqqApi::Stubs::Stub.new(nil, 7)
    
    refute_equal NotepadqqApi::Stubs::Notepadqq.new("test", 7),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 7)
    
  end
  
end