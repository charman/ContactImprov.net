require 'test_helper'

class StudioTest < ActiveSupport::TestCase
  fixtures :studios

  def test_acts_as_versioned
    s = Studio.new
    s.name = 'Foo'
    assert_nil s.version
    assert s.save!
    assert s.version == 1
    assert s.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_name
    s = Studio.new
    s.name = 'name'
    assert_equal s.valid?, true
  end

  def test_should_not_validate_with_empty_name
    s = Studio.new
    s.name = ''
    assert_equal s.valid?, false
  end

  # def test_should_create_entity
  #   s = Studio.new
  #   s.name = 'Foo'
  #   assert_nil s.entity
  #   assert_not_nil s.save!
  #   s.reload
  #   assert_not_nil s.entity
  #   assert_equal s, s.entity.resource
  # end
  
end
