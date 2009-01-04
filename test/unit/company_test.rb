require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  fixtures :companies

  def test_acts_as_versioned
    c = Company.new
    c.name = 'Foo'
    assert_nil c.version
    assert c.save!
    assert c.version == 1
    assert c.save!    #  Verify that versions_conditions_met? does not fail
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

  def test_should_sanitize_name
    c = Company.new
    c.name = '<b>sanitized</b>'
    c.save!
    c.reload
    assert_equal 'sanitized', c.name
  end
 
end
