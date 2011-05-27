require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

  def test_acts_as_versioned
    p = PhoneNumber.new
    p.number = '585-275-4822'
    assert_nil p.version
    assert p.save!
    assert p.version == 1
    assert p.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_number
    p = PhoneNumber.new
    p.number = '585-275-4822'
    assert_equal p.valid?, true
  end

  def test_should_not_validate_with_empty_number
    p = PhoneNumber.new
    p.number = ''
    assert_equal p.valid?, false
  end

  def test_should_sanitize_number
    p = PhoneNumber.new
    p.number = '<b>sanitized</b>'
    p.save!
    p.reload
    assert_equal 'sanitized', p.number
  end
  
end
