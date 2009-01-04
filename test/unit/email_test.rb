require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  fixtures :emails

  def test_acts_as_versioned
    e = Email.new
    e.address = 'charman@acm.org'
    assert_nil e.version
    assert e.save!
    assert e.version == 1
    assert e.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_address
    e = Email.new
    e.address = 'charman@acm.org'
    assert_equal e.valid?, true
  end

  def test_should_not_validate_with_empty_address
    e = Email.new
    e.address = ''
    assert_equal e.valid?, false
  end

  def test_should_sanitize_address
    e = Email.new
    e.address = '<b>sanitized</b>'
    e.save!
    e.reload
    assert_equal 'sanitized', e.address
  end
  
end
