require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  def test_acts_as_versioned
    o = Organization.new
    o.name = 'Foo'
    assert_nil o.version
    assert o.save!
    assert o.version == 1
    assert o.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_name
    o = Organization.new
    o.name = 'name'
    assert_equal o.valid?, true
  end

  def test_should_not_validate_with_empty_name
    o = Organization.new
    o.name = ''
    assert_equal o.valid?, false
  end

  def test_should_sanitize_name_and_description
    o = Organization.new
    o.name = '<b>sanitized</b>'
    o.description = '<b>sanitized</b>'
    o.save!
    o.reload
    assert_equal 'sanitized', o.name
    assert_equal 'sanitized', o.description
  end
  
end
