require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures :country_names, :locations

  include GeoKit::Geocoders

  def test_acts_as_versioned
    l = Location.new
    assert_nil l.version
    l.city_name = 'City Name'
    l.country_name = CountryName.find_by_english_name('Canada')
    assert l.save!
    assert l.version == 1
    assert l.save!    #  Verify that versions_conditions_met? does not fail
  end

  def test_should_be_in_usa
    assert locations(:quentin_address).is_in_usa?
  end

  def test_should_geocode_addresss_using_google
    l = GoogleGeocoder.geocode('100 Spear St, San Francisco, CA')
    assert l.success
    assert_equal l.precision, 'address'
  end
  
  def test_should_sanitize_location_fields
    l = Location.new
    l.street_address_line_1 = '<b>sanitized</b>'
    l.street_address_line_2 = '<b>sanitized</b>'
    l.city_name = '<b>sanitized</b>'
    l.region_name = '<b>sanitized</b>'
    l.postal_code = '<b>sanitized</b>'
    l.country_name = CountryName.find_by_english_name('Canada')
    l.save!
    l.reload
    assert_equal 'sanitized', l.street_address_line_1
    assert_equal 'sanitized', l.street_address_line_2
    assert_equal 'sanitized', l.city_name
    assert_equal 'sanitized', l.region_name
    assert_equal 'sanitized', l.postal_code
  end
  
end
