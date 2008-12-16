require 'test_helper'

class UrlTest < ActiveSupport::TestCase
#  fixtures :entities, :urls
  fixtures :urls

  def test_acts_as_versioned
    u = Url.new
    u.address = 'http://craigharman.net/'
#    u.for_entity = entities(:quentin)
    assert_nil u.version
    assert u.save!
    assert u.version == 1
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

  # def test_should_create_entity
  #   u = Url.new
  #   u.address = 'http://craigharman.net/'
  #   u.for_entity = entities(:quentin)
  #   assert_nil u.entity
  #   assert_not_nil u.save!
  #   u.reload
  #   assert_not_nil u.entity
  #   assert_equal u, u.entity.resource
  # end

  def test_should_add_or_remove_protocol
    u = Url.new
    u.address = 'craigharman.net/'
#    u.for_entity = entities(:quentin)
    u.save!
    u.reload
    assert_match /:\/\//, u.address
    assert_match /:\/\//, u.address_with_protocol
    assert_no_match /:\/\//, u.address_without_protocol
  end

end
