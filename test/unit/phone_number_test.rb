require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
#  fixtures :entities, :phone_numbers
  fixtures :phone_numbers

  def test_acts_as_versioned
    p = PhoneNumber.new
    p.number = '585-275-4822'
#    p.for_entity = entities(:quentin)
    assert_nil p.version
    assert p.save!
    assert p.version == 1
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

  # def test_should_create_entity
  #   p = PhoneNumber.new
  #   p.number = '585-275-4822'
  #   p.for_entity = entities(:quentin)
  #   assert_nil p.entity
  #   assert_not_nil p.save!
  #   p.reload
  #   assert_not_nil p.entity
  #   assert_equal p, p.entity.resource
  # end
  
end
