require 'test_helper'

class EventControllerTest < ActionController::TestCase
  require "rubygems"
  require "ruby-debug"
  Debugger.start


  fixtures :contact_events, :country_names, :emails, :locations, :phone_numbers, :urls, :us_states, :users


  #  Test 'create' action

  def test_should_accept_contact_event_application
    login_as :quentin
    post :create, 
      :contact_event => {
        :title            => contact_events(:complete_contact_event).title,
        :description      => contact_events(:complete_contact_event).description,
        :start_date       => contact_events(:complete_contact_event).start_date,
        :end_date         => contact_events(:complete_contact_event).end_date
      },
      :event => {
        :email => { :address => emails(:complete_contact_event).address },
        :location => @@default_location_fields,
        :phone_number => { :number => phone_numbers(:complete_contact_event).number },
        :ci_url => { :address => urls(:complete_contact_event).address }
      }
    assert_redirected_to :controller => 'user', :action => 'index'
    new_event = ContactEvent.find(:last)    
    assert_equal users(:quentin), new_event.owner_user
    assert_equal contact_events(:complete_contact_event).title,       new_event.title
    assert_equal contact_events(:complete_contact_event).description, new_event.description
    assert_equal contact_events(:complete_contact_event).start_date,  new_event.start_date
    assert_equal contact_events(:complete_contact_event).end_date,    new_event.end_date
    assert_equal emails(:complete_contact_event).address, new_event.email.address
    verify_default_location_fields(new_event.location)
    assert_equal phone_numbers(:complete_contact_event).number, new_event.phone_number.number
    assert_match /#{urls(:complete_contact_event).address}/, new_event.url.address
  end

  def test_should_accept_contact_event_application_with_empty_email_and_phone_number_and_url
    login_as :quentin
    post :create, 
      :contact_event => {
        :title            => contact_events(:complete_contact_event).title,
        :description      => contact_events(:complete_contact_event).description,
        :start_date       => contact_events(:complete_contact_event).start_date,
        :end_date         => contact_events(:complete_contact_event).end_date
      },
      :event => {
        :email => { :address => '' },
        :location => @@default_location_fields,
        :phone_number => { :number => '' },
        :ci_url => { :address => '' }
      }
    assert_redirected_to :controller => 'user', :action => 'index'
    new_event = ContactEvent.find(:last)
    assert_equal contact_events(:complete_contact_event).title,       new_event.title
    assert_equal contact_events(:complete_contact_event).description, new_event.description
    assert_equal contact_events(:complete_contact_event).start_date,  new_event.start_date
    assert_equal contact_events(:complete_contact_event).end_date,    new_event.end_date
    assert_nil new_event.email
    verify_default_location_fields(new_event.location)
    assert_nil new_event.phone_number
    assert_nil new_event.url
  end

  def test_should_not_accept_contact_event_application_with_empty_title
    login_as :quentin
    post :create, 
      :contact_event => {
        :title            => '',
        :description      => contact_events(:complete_contact_event).description,
        :start_date       => contact_events(:complete_contact_event).start_date,
        :end_date         => contact_events(:complete_contact_event).end_date
      },
      :event => {
        :email => { :address => emails(:complete_contact_event).address },
        :location => @@default_location_fields,
        :phone_number => { :number => phone_numbers(:complete_contact_event).number },
        :ci_url => { :address => urls(:complete_contact_event).address }
      }
    assert_redirected_to :action => 'new'   # lemma: redirected to new if application rejected
  end

  def test_should_restrict_access_to_create_to_logged_in_users
    get :create
    assert_redirected_to :controller => 'session', :action => 'new'
  end


  #  Test 'edit' action

  def test_should_fail_if_no_event_id_provided
    login_as :quentin
    get :edit
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /No Event ID was provided/, @response.body
  end

  def test_should_fail_if_bad_event_id_provided
    login_as :quentin
    get :edit, :id => 'bad'
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Unable to find the Event you are searching for/, @response.body
  end

  def test_should_allow_access_to_edit_to_owner_user
    login_as :quentin
    get :edit, :id => contact_events(:complete_contact_event).contact_event_id
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /You do not have permission to edit this Event/, @response.body
  end
  
  def test_should_restrict_access_to_edit_to_logged_in_users
    get :edit, :id => contact_events(:complete_contact_event).contact_event_id
    assert_redirected_to :controller => 'session', :action => 'new'
  end
  
  def test_should_deny_access_to_edit_to_non_owner_user
    login_as :aaron
    get :edit, :id => contact_events(:complete_contact_event).contact_event_id
    assert_select "[class=errorExplanation]"
    assert_response :success
    assert_match /You do not have permission to edit this Event/, @response.body
  end

  #  Verify that we can update the fields to new values

  #  If we edit an event and delete the contents of the email/phone_number/url fields,
  #   verify that the models were deleted from the database  (OR NOT?)


  #  Test 'list' action

  def test_should_allow_access_to_list
    get :list
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end


  #  Test 'new' action
  
  def test_should_restrict_access_to_new_to_logged_in_users
    get :new
    assert_redirected_to :controller => 'session', :action => 'new'
  end
  

end
