require 'test_helper'

class ContactEventTest < ActiveSupport::TestCase
  fixtures :contact_events

  def test_acts_as_versioned
    c = ContactEvent.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_nil c.version
    assert c.save!
    assert c.version == 1
    assert c.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_title_description_and_dates
    c = ContactEvent.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_equal c.valid?, true
  end

  def test_should_not_validate_without_title
    c = ContactEvent.new
    c.title = ''
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_description
    c = ContactEvent.new
    c.title = 'New Event'
    c.description = ''
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_start_date
    c = ContactEvent.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.end_date   = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_end_date
    c = ContactEvent.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
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
