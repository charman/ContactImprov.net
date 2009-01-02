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

  def test_should_reorder_start_and_end_dates
    older_date = '1-1-2009'.to_date
    newer_date = '1-2-2009'.to_date
    c = ContactEvent.new
    c.title = 'TimeTest Event'
    c.description = 'Verify that times are ordered correctly upon save'
    c.start_date = newer_date
    c.end_date = older_date
    assert c.save!
    c.reload
    assert_equal older_date, c.start_date
    assert_equal newer_date, c.end_date
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
