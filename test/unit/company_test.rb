require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  fixtures :companies

  def test_acts_as_versioned
    c = Company.new
    c.name = 'Foo'
    assert_nil c.version
    assert c.save!
    assert c.version == 1
  end

  def test_should_validate_with_name
    c = Company.new
    c.name = 'name'
    assert_equal c.valid?, true
  end

  def test_should_not_validate_with_empty_name
    c = Company.new
    c.name = ''
    assert_equal c.valid?, false
  end

  # def test_should_create_entity
  #   c = Company.new
  #   c.name = 'Foo'
  #   assert_nil c.entity
  #   assert_not_nil c.save!
  #   c.reload
  #   assert_not_nil c.entity
  #   assert_equal c, c.entity.resource
  # end
  
end
