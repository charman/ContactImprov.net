require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def test_acts_as_versioned
    p = Person.new
    assert_nil p.version
    p.last_name = 'Foo'
    assert p.save!
    assert p.version == 1
    assert p.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_last_name
    p = Person.new
    p.last_name = 'last_name'
    assert_equal p.valid?, true
  end

  def test_should_not_validate_with_empty_last_name
    p = Person.new
    p.last_name = ''
    assert_equal p.valid?, false
  end
  
  def test_should_sanitize_first_and_last_name
    p = Person.new
    p.first_name = '<b>sanitized</b>'
    p.last_name = '<b>sanitized</b>'
    p.save!
    p.reload
    assert_equal 'sanitized', p.first_name
    assert_equal 'sanitized', p.last_name
  end
  
end
