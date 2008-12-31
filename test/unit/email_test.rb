require 'test_helper'

class EmailTest < ActiveSupport::TestCase
#  fixtures :emails, :entities
  fixtures :emails

  def test_acts_as_versioned
    e = Email.new
    e.address = 'charman@acm.org'
#    e.for_entity = entities(:quentin)
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

  # def test_should_create_entity
  #   e = Email.new
  #   e.address = 'charman@acm.org'
  #   e.for_entity = entities(:quentin)
  #   assert_nil e.entity
  #   assert_not_nil e.save!
  #   e.reload
  #   assert_not_nil e.entity
  #   assert_equal e, e.entity.resource
  # end
  
end
