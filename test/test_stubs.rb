require 'test/unit'
require 'notepadqq_api/stubs'

class StubsTest < Test::Unit::TestCase
  
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
    
    assert_not_equal NotepadqqApi::Stubs::Notepadqq.new(nil, 1),
             NotepadqqApi::Stubs::Stub.new(nil, 2)
    
    assert_not_equal NotepadqqApi::Stubs::Stub.new(nil, 1),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 2)
    
    assert_not_equal NotepadqqApi::Stubs::Stub.new(nil, 1),
             NotepadqqApi::Stubs::Stub.new(nil, 2)
    
    assert_not_equal NotepadqqApi::Stubs::Notepadqq.new(nil, 1),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 2)
    
    # Different channel
    
    assert_not_equal NotepadqqApi::Stubs::Notepadqq.new("test", 7),
             NotepadqqApi::Stubs::Stub.new(nil, 7)
    
    assert_not_equal NotepadqqApi::Stubs::Stub.new("test", 7),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 7)
    
    assert_not_equal NotepadqqApi::Stubs::Stub.new("test", 7),
             NotepadqqApi::Stubs::Stub.new(nil, 7)
    
    assert_not_equal NotepadqqApi::Stubs::Notepadqq.new("test", 7),
             NotepadqqApi::Stubs::Notepadqq.new(nil, 7)
    
  end
  
end