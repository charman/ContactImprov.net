require 'test_helper'

class EventEntryTest < ActiveSupport::TestCase

  def test_acts_as_versioned
    c = EventEntry.new
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
    c = EventEntry.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_equal c.valid?, true
  end

  def test_should_not_validate_without_title
    c = EventEntry.new
    c.title = ''
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_description
    c = EventEntry.new
    c.title = 'New Event'
    c.description = ''
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_start_date
    c = EventEntry.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.end_date   = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_end_date
    c = EventEntry.new
    c.title = 'New Event'
    c.description = 'Fantastic new event'
    c.start_date = DateTime.now
    assert_equal c.valid?, false
  end

  def test_should_reorder_start_and_end_dates
    older_date = '1-1-2009'.to_date
    newer_date = '1-2-2009'.to_date
    c = EventEntry.new
    c.title = 'TimeTest Event'
    c.description = 'Verify that times are ordered correctly upon save'
    c.start_date = newer_date
    c.end_date = older_date
    assert c.save!
    c.reload
    assert_equal older_date, c.start_date
    assert_equal newer_date, c.end_date
    #  Verify that saving again doesn't reorder start/end dates
    assert c.save!
    c.reload
    assert_equal older_date, c.start_date
    assert_equal newer_date, c.end_date
  end

  def test_should_sanitize_title_description_and_cost
    c = EventEntry.new
    c.title = '<b>sanitized</b>'
    c.description = '<b>sanitized</b>'
    c.cost = '<b>sanitized</b>'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    c.save!
    c.reload
    assert_equal 'sanitized', c.title
    assert_equal 'sanitized', c.description
    assert_equal 'sanitized', c.cost
  end
 
  def test_should_not_break_textile_url_markup
    c = EventEntry.new
    c.title = '"quoted string"'
    c.description = '["craig":http://craigharman.net]'
    c.cost = '["craig harman":http://craigharman.net] ["ci":http://contactimprov.net] ["ci":./foo] ["ci":/foo]'
    c.start_date = DateTime.now
    c.end_date   = DateTime.now
    c.save!
    c.reload
    assert_equal '"quoted string"', c.title
    assert_equal '["craig":http://craigharman.net]', c.description
    assert_equal '["craig harman":http://craigharman.net] ["ci":http://contactimprov.net] ["ci":./foo] ["ci":/foo]', c.cost
  end
 
 
  def test_should_find_future_us_event
    new_york = UsState.find_by_abbreviation('NY')
    assert_not_nil new_york
    future_events = EventEntry.find_future_by_us_state(new_york)
    assert_equal 1, future_events.size
    assert_equal event_entries(:future_us_event_entry), future_events[0]
  end
 
  def test_should_find_future_canadian_event
    canada = CountryName.find_by_english_name('Canada')
    assert_not_nil canada
    future_events = EventEntry.find_future_by_country_name(canada)
    assert_equal 1, future_events.size
    assert_equal event_entries(:future_canadian_event_entry), future_events[0]
  end
 
end
