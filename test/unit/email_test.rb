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
    assert_equal true, e.valid?
  end

  def test_should_validate_address_with_whitespace
    e = Email.new
    e.address = "\tcharman@acm.org "
    assert_equal true, e.valid?
  end

  def test_should_not_validate_with_empty_address
    e = Email.new
    e.address = ''
    assert_equal false, e.valid?
  end

  def test_should_not_validate_address_with_html
    e = Email.new
    e.address = '<b>sanitized@contactimprov.org</b>'
    assert !e.save
    assert_match /does not appear to be a valid/, e.errors[:address].first
  end

  def test_should_not_validate_email_address
    e = Email.new
    e.address = 'not_a_valid_email'
    assert !e.save
    assert_match /does not appear to be a valid/, e.errors[:address].first
  end
  
end
