require 'test_helper'

class CountryNameTest < ActiveSupport::TestCase
  fixtures :country_names

  def test_should_find_by_english_name
    assert_equal CountryName.find_by_english_name_or_altname('United States'), country_names(:united_states)
    assert_equal CountryName.find_by_english_name_or_altname('United Kingdom'), country_names(:united_kingdom)
    assert_equal CountryName.find_by_english_name_or_altname('Canada'), country_names(:canada)
  end

  def test_should_find_us_by_alternate_names
    assert_equal CountryName.find_by_english_name_or_altname('USA'), country_names(:united_states)
    assert_equal CountryName.find_by_english_name_or_altname('usa'), country_names(:united_states)
    assert_equal CountryName.find_by_english_name_or_altname(' usa '), country_names(:united_states)
  end

  def test_should_find_uk_by_alternate_names
    assert_equal CountryName.find_by_english_name_or_altname('england'), country_names(:united_kingdom)
    assert_equal CountryName.find_by_english_name_or_altname('great britain'), country_names(:united_kingdom)
    assert_equal CountryName.find_by_english_name_or_altname('uk'), country_names(:united_kingdom)
    assert_equal CountryName.find_by_english_name_or_altname('u.k.'), country_names(:united_kingdom)
    assert_nil CountryName.find_by_english_name_or_altname('ukrain')
    assert_not_equal CountryName.find_by_english_name_or_altname('ukraine'), country_names(:united_kingdom)
  end

  def test_should_be_usa
    assert CountryName.is_usa?('USA')
    assert CountryName.is_usa?('usa')
    assert CountryName.is_usa?(' usa ')
    assert CountryName.is_usa?(' united states ')
    assert country_names(:united_states).is_usa?
  end
end
