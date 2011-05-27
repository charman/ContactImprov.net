require 'test_helper'

class UsStateTest < ActiveSupport::TestCase

  def test_should_find_with_name_or_abbreviation
    assert_equal us_states(:new_york), UsState.find_by_name_or_abbreviation('New York')
    assert_equal us_states(:new_york), UsState.find_by_name_or_abbreviation('NY')
    assert_equal us_states(:new_york), UsState.find_by_name_or_abbreviation('new york')
    assert_equal us_states(:new_york), UsState.find_by_name_or_abbreviation('ny')
    assert_equal us_states(:new_york), UsState.find_by_name_or_abbreviation('nEw yORk')
    assert_equal us_states(:new_york), UsState.find_by_name_or_abbreviation('nY')
  end

  def test_should_not_find_with_partial_name_or_abbreviation
    assert_nil UsState.find_by_name_or_abbreviation('nEw yOR')
    assert_nil UsState.find_by_name_or_abbreviation('n')
  end
end
