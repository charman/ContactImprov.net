require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

  #  Test 'calendar' action

  def test_should_get_calendar
    get :feed
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_match /BEGIN:VEVENT/, @response.body
    assert_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end

  def test_should_get_calendar_for_canada
    get :feed, :country_name => country_names(:canada).underlined_english_name
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_match /BEGIN:VEVENT/, @response.body
    assert_no_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end

  def test_should_get_calendar_for_new_york
    get :feed, :country_name => country_names(:united_states).underlined_english_name, 
      :us_state => us_states(:new_york).underlined_name
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_match /BEGIN:VEVENT/, @response.body
    assert_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_no_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end

  def test_should_get_empty_calendar_for_pennsylvania
    get :feed, :country_name => country_names(:united_states).underlined_english_name, 
      :us_state => us_states(:pennsylvania).underlined_name
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_no_match /BEGIN:VEVENT/, @response.body
    assert_no_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_no_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end


  #  Test 'index' action

  test "get index" do
    get :index
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
