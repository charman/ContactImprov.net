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

#  def test_should_create_entity
#    l = Location.new
#    l.city_name = 'Toronto'
#    l.country_name = CountryName.find_by_english_name('Canada')
#    assert_nil l.entity
#    assert_not_nil l.save!
#    l.reload
#    assert_not_nil l.entity
#    assert_equal l, l.entity.resource
#  end
end
