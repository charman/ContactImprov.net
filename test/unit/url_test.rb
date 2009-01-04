require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  fixtures :urls

  def test_acts_as_versioned
    u = Url.new
    u.address = 'http://craigharman.net/'
    assert_nil u.version
    assert u.save!
    assert u.version == 1
    assert u.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_address
    u = Url.new
    u.address = 'http://craigharman.net/'
    assert_equal u.valid?, true
  end

  def test_should_not_validate_with_empty_address
    u = Url.new
    u.address = ''
    assert_equal u.valid?, false
  end

  def test_should_add_or_remove_protocol
    u = Url.new
    u.address = 'craigharman.net/'
    u.save!
    u.reload
    assert_match /:\/\//, u.address
    assert_match /:\/\//, u.address_with_protocol
    assert_no_match /:\/\//, u.address_without_protocol
  end

  def test_should_sanitize_address
    u = Url.new
    u.address = '<b>sanitized</b>'
    u.save!
    u.reload
    assert_equal 'http://sanitized', u.address
  end

end
