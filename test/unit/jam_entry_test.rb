require 'test_helper'

class JamEntryTest < ActiveSupport::TestCase
  fixtures :jam_entries

  def test_acts_as_versioned
    c = JamEntry.new
    c.title = 'New Jam'
    c.description = 'Fantastic new jam'
    c.times = 'Whenever'
    c.cost = 'Billions'
    assert_nil c.version
    assert c.save!
    assert c.version == 1
    assert c.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_validate_with_title_description_and_dates
    c = JamEntry.new
    c.title = 'New Jam'
    c.description = 'Fantastic new jam'
    c.times = 'Whenever'
    c.cost = 'Billions'
    assert_equal c.valid?, true
  end

  def test_should_not_validate_without_title
    c = JamEntry.new
    c.title = ''
    c.description = 'Fantastic new jam'
    c.times = 'Whenever'
    c.cost = 'Billions'
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_description
    c = JamEntry.new
    c.title = 'New Jam'
    c.description = ''
    c.times = 'Whenever'
    c.cost = 'Billions'
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_times
    c = JamEntry.new
    c.title = 'New Jam'
    c.description = 'Fantastic new jam'
    c.times = ''
    c.cost = 'Billions'
    assert_equal c.valid?, false
  end

  def test_should_not_validate_without_cost
    c = JamEntry.new
    c.title = 'New Jam'
    c.description = 'Fantastic new jam'
    c.times = 'Whenever'
    c.cost = ''
    assert_equal c.valid?, false
  end

  def test_should_sanitize_accessible_attributes
    c = JamEntry.new
    c.title = '<b>sanitized</b>'
    c.description = '<b>sanitized</b>'
    c.times = '<b>sanitized</b>'
    c.cost = '<b>sanitized</b>'
    c.save!
    c.reload
    assert_equal 'sanitized', c.title
    assert_equal 'sanitized', c.description
    assert_equal 'sanitized', c.times
    assert_equal 'sanitized', c.cost
  end
 
end
