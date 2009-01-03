require 'test_helper'

class EventControllerTest < ActionController::TestCase
  require "rubygems"
  require "ruby-debug"
  Debugger.start


  fixtures :contact_events, :country_names, :emails, :locations, :people, :phone_numbers, :urls, :us_states, :users


  #  Test 'create' action

  def test_should_accept_contact_event_application
    login_as :quentin
    post :create, 
      :contact_event => {
        :title            => contact_events(:complete_contact_event).title,
        :description      => contact_events(:complete_contact_event).description,
        :fee_description  => contact_events(:complete_contact_event).fee_description,
        :start_date       => contact_events(:complete_contact_event).start_date,
        :end_date         => contact_events(:complete_contact_event).end_date
      },
      :event => {
        :person => { 
          :first_name => people(:complete_contact_event).first_name, 
          :last_name  => people(:complete_contact_event).last_name
        },
        :email => { :address => emails(:complete_contact_event).address },
        :location => @@default_location_fields,
        :phone_number => { :number => phone_numbers(:complete_contact_event).number },
        :ci_url => { :address => urls(:complete_contact_event).address }
      }
    assert_redirected_to :controller => 'user', :action => 'index'
    new_event = ContactEvent.find(:last)    
    assert_equal users(:quentin), new_event.owner_user
    assert_equal contact_events(:complete_contact_event).title,           new_event.title
    assert_equal contact_events(:complete_contact_event).description,     new_event.description
    assert_equal contact_events(:complete_contact_event).fee_description, new_event.fee_description
    assert_equal contact_events(:complete_contact_event).start_date,      new_event.start_date
    assert_equal contact_events(:complete_contact_event).end_date,        new_event.end_date
    assert_equal people(:complete_contact_event).first_name,              new_event.person.first_name
    assert_equal people(:complete_contact_event).last_name,               new_event.person.last_name
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

  def test_should_not_create_contact_event_application_with_missing_mandatory_fields
    login_as :quentin
    post :create, 
      :contact_event => {
        :title            => nil,
        :description      => nil,
        :start_date       => nil,
        :end_date         => nil
      },
      :event => {
        :email => nil,
        :location => @@empty_location_fields,
        :phone_number => nil,
        :ci_url => nil
      }
    verify_error_messages_for_missing_fields
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
    assert_select "[class=errorExplanation]", false
  end
  
  def test_should_allow_access_to_edit_to_admin
    login_as :admin
    get :edit, :id => contact_events(:complete_contact_event).contact_event_id
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end
  
  def test_should_restrict_access_to_edit_to_logged_in_users
    get :edit, :id => contact_events(:complete_contact_event).contact_event_id
    assert_redirected_to :controller => 'session', :action => 'new'
  end
  
  def test_should_deny_access_to_edit_to_non_owner_user
    login_as :aaron
    get :edit, :id => contact_events(:complete_contact_event).contact_event_id
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /You do not have permission to edit this Event/, @response.body
  end

  def test_should_not_edit_contact_event_application_with_missing_mandatory_fields
    login_as :quentin
    put :edit, :id => contact_events(:complete_contact_event).contact_event_id,
      :contact_event => {
        :title            => nil,
        :description      => nil,
        :start_date       => nil,
        :end_date         => nil
      },
      :event => {
        :email => nil,
        :location => @@empty_location_fields,
        :phone_number => nil,
        :ci_url => nil
      }
    verify_error_messages_for_missing_fields

    #  Verify that field values have not changed
    new_event = ContactEvent.find(contact_events(:complete_contact_event).contact_event_id)
    assert_equal users(:quentin), new_event.owner_user
    assert_equal contact_events(:complete_contact_event).title,       new_event.title
    assert_equal contact_events(:complete_contact_event).description, new_event.description
    assert_equal contact_events(:complete_contact_event).start_date,  new_event.start_date
    assert_equal contact_events(:complete_contact_event).end_date,    new_event.end_date
    assert_equal emails(:complete_contact_event).address, new_event.email.address
#    verify_default_location_fields(new_event.location)
    assert_equal phone_numbers(:complete_contact_event).number, new_event.phone_number.number
  end

  def test_should_let_owner_user_edit_contact_event_application
    login_as :quentin
    post_data_to_edit_and_test_response
  end

  def test_should_let_admin_edit_contact_event_application
   login_as :admin
   post_data_to_edit_and_test_response
  end


  #  TODO: If we edit an event and delete the contents of the email/phone_number/url fields,
  #         verify that the models were deleted from the database  (OR NOT?)


  #  Test 'list' action

  def test_should_allow_access_to_list
    get :list
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end


  #  Test 'new' action
  
  def test_should_allow_access_to_new_to_logged_in_users
    login_as :quentin
    get :new
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end
  
  def test_should_restrict_access_to_new_to_logged_in_users
    get :new
    assert_redirected_to :controller => 'session', :action => 'new'
  end
  

protected

  def post_data_to_edit_and_test_response
    put :edit, :id => contact_events(:complete_contact_event).contact_event_id,
      :contact_event => {
        :title            => 'newtitle',
        :description      => 'newdescription',
        :fee_description  => 'newfeedescription',
        :start_date       => '2006-06-06',
        :end_date         => '2006-06-06'
      },
      :event => {
        :email => { :address => 'newaddress@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-666-6666' },
        :ci_url => { :address => 'http://contactimprov.org/newurl/' }
      }
    assert_redirected_to :controller => 'user', :action => 'index'
    
    #  Verify that field values have been updated
    updated_event = ContactEvent.find(contact_events(:complete_contact_event).contact_event_id)
    #  owner_user should not be updated when Contact Event is edited by an admin
    assert_equal users(:quentin),                    updated_event.owner_user
    assert_equal 'newtitle',                         updated_event.title
    assert_equal 'newdescription',                   updated_event.description
    assert_equal 'newfeedescription',                updated_event.fee_description
    assert_equal '2006-06-06',                       updated_event.start_date.strftime('%Y-%m-%d')
    assert_equal '2006-06-06',                       updated_event.end_date.strftime('%Y-%m-%d')
    assert_equal 'newaddress@contactimprov.org',     updated_event.email.address
    verify_default_location_fields(updated_event.location)
    assert_equal '666-666-6666',                     updated_event.phone_number.number
    assert_equal 'http://contactimprov.org/newurl/', updated_event.url.address
  end

  def verify_error_messages_for_missing_fields
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /End date can.t be blank/, @response.body
    assert_match /Start date can.t be blank/, @response.body
    assert_match /Title can.t be blank/, @response.body
    assert_match /Description can.t be blank/, @response.body
    assert_match /Country name .. is not the name of a country in our database/, @response.body
    assert_match /City name can.t be blank/, @response.body
  end

end
