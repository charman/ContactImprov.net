require 'test_helper'

class JamsControllerTest < ActionController::TestCase

  fixtures :jam_entries, :country_names, :emails, :locations, :people, :phone_numbers, :urls, :us_states, :users


  #  Test 'list' action

  def test_should_allow_access_to_list
    get :list
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
