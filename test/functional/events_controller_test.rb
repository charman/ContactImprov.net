require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  #  Test 'calendar' action

  def test_should_get_calendar
    get :calendar
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_match /BEGIN:VEVENT/, @response.body
    assert_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end

  def test_should_get_calendar_for_canada
    get :calendar, :country_name => country_names(:canada).underlined_english_name
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_match /BEGIN:VEVENT/, @response.body
    assert_no_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end

  def test_should_get_calendar_for_new_york
    get :calendar, :country_name => country_names(:united_states).underlined_english_name, 
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
    get :calendar, :country_name => country_names(:united_states).underlined_english_name, 
      :us_state => us_states(:pennsylvania).underlined_name
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /BEGIN:VCALENDAR/, @response.body
    assert_match /END:VCALENDAR/, @response.body
    assert_no_match /BEGIN:VEVENT/, @response.body
    assert_no_match /#{event_entries(:future_us_event_entry).title}/, @response.body
    assert_no_match /#{event_entries(:future_canadian_event_entry).title}/, @response.body
  end


  #  Test 'create' action

  def test_should_accept_event_entry_application
    login_as :quentin
    post :create, 
      :event_entry => {
        :title            => event_entries(:complete_event_entry).title,
        :description      => event_entries(:complete_event_entry).description,
        :cost             => event_entries(:complete_event_entry).cost,
        :start_date       => event_entries(:complete_event_entry).start_date,
        :end_date         => event_entries(:complete_event_entry).end_date
      },
      :entry => {
        :person => { 
          :first_name => people(:complete_event_entry).first_name, 
          :last_name  => people(:complete_event_entry).last_name
        },
        :email => { :address => emails(:complete_event_entry).address },
        :location => @@default_location_fields,
        :phone_number => { :number => phone_numbers(:complete_event_entry).number },
        :ci_url => { :address => urls(:complete_event_entry).address }
      }
    new_entry = EventEntry.find(:last)    
    assert_redirected_to :controller => 'events', :action => 'show', :id => new_entry.id
    assert_equal users(:quentin), new_entry.owner_user
    assert_equal event_entries(:complete_event_entry).title,           new_entry.title
    assert_equal event_entries(:complete_event_entry).description,     new_entry.description
    assert_equal event_entries(:complete_event_entry).cost,            new_entry.cost
    assert_equal event_entries(:complete_event_entry).start_date,      new_entry.start_date
    assert_equal event_entries(:complete_event_entry).end_date,        new_entry.end_date
    assert_equal people(:complete_event_entry).first_name,             new_entry.person.first_name
    assert_equal people(:complete_event_entry).last_name,              new_entry.person.last_name
    assert_equal emails(:complete_event_entry).address, new_entry.email.address
    verify_default_location_fields(new_entry.location)
    assert_equal phone_numbers(:complete_event_entry).number, new_entry.phone_number.number
    assert_match /#{urls(:complete_event_entry).address}/, new_entry.url.address
    assert_equal(1, @emails.size)
    assert_match /New Event/, @emails.first.subject
  end

  def test_should_accept_event_entry_application_with_empty_email_and_phone_number_and_url
    login_as :quentin
    post :create, 
      :event_entry => {
        :title            => event_entries(:complete_event_entry).title,
        :description      => event_entries(:complete_event_entry).description,
        :start_date       => event_entries(:complete_event_entry).start_date,
        :end_date         => event_entries(:complete_event_entry).end_date
      },
      :entry => {
        :email => { :address => '' },
        :location => @@default_location_fields,
        :phone_number => { :number => '' },
        :ci_url => { :address => '' }
      }
    new_entry = EventEntry.find(:last)
    assert_redirected_to :controller => 'events', :action => 'show', :id => new_entry.id
    assert_equal event_entries(:complete_event_entry).title,       new_entry.title
    assert_equal event_entries(:complete_event_entry).description, new_entry.description
    assert_equal event_entries(:complete_event_entry).start_date,  new_entry.start_date
    assert_equal event_entries(:complete_event_entry).end_date,    new_entry.end_date
    assert_nil new_entry.email
    verify_default_location_fields(new_entry.location)
    assert_nil new_entry.phone_number
    assert_nil new_entry.url
    assert_equal(1, @emails.size)
    assert_match /New Event/, @emails.first.subject
  end

  def test_should_not_create_event_entry_application_with_missing_mandatory_fields
    login_as :quentin
    post :create, 
      :event_entry => {
        :title            => nil,
        :description      => nil,
        :start_date       => nil,
        :end_date         => nil
      },
      :entry => {
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


  #  Test 'delete' action

  def test_should_allow_admin_to_delete_event
    login_as :admin
    get :delete, :id => 100
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_equal false, EventEntry.exists?(100)
  end

  def test_should_allow_user_to_delete_event
    login_as :quentin
    get :delete, :id => 100
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_equal false, EventEntry.exists?(100)
  end

  def test_should_not_delete_attached_models
    login_as :quentin
    person_id       = event_entries(:complete_event_entry).person.id
    location_id     = event_entries(:complete_event_entry).location.id
    email_id        = event_entries(:complete_event_entry).email.id
    phone_number_id = event_entries(:complete_event_entry).phone_number.id
    url_id          = event_entries(:complete_event_entry).url.id
    assert_not_nil person_id
    assert_not_nil location_id
    get :delete, :id => 100
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_equal false, EventEntry.exists?(100)
    assert_not_nil Person.find(person_id)
    assert_not_nil Location.find(location_id)
    assert_not_nil Email.find(email_id)
    assert_not_nil PhoneNumber.find(phone_number_id)
    assert_not_nil Url.find(url_id)
  end

  def test_should_not_delete_unknown_event
    login_as :admin
    get :delete, :id => 6969
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Unable to find the Event/, @response.body
  end

  def test_should_not_let_user_delete_someone_elses_event
    login_as :non_admin_without_person_entry
    get :delete, :id => 100
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Access Denied/, @response.body
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
    get :edit, :id => event_entries(:complete_event_entry).event_entry_id
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end
  
  def test_should_allow_access_to_edit_to_admin
    login_as :admin
    get :edit, :id => event_entries(:complete_event_entry).event_entry_id
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end
  
  def test_should_restrict_access_to_edit_to_logged_in_users
    get :edit, :id => event_entries(:complete_event_entry).event_entry_id
    assert_redirected_to :controller => 'session', :action => 'new'
  end
  
  def test_should_deny_access_to_edit_to_non_owner_user
    login_as :non_admin_without_person_entry
    get :edit, :id => event_entries(:complete_event_entry).event_entry_id
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /You do not have permission to edit this Event/, @response.body
  end

  def test_should_not_edit_event_entry_application_with_missing_mandatory_fields
    login_as :quentin
    put :edit, :id => event_entries(:complete_event_entry).event_entry_id,
      :event_entry => {
        :title            => nil,
        :description      => nil,
        :start_date       => nil,
        :end_date         => nil
      },
      :entry => {
        :email => nil,
        :location => @@empty_location_fields,
        :phone_number => nil,
        :ci_url => nil
      }
    verify_error_messages_for_missing_fields

    #  Verify that field values have not changed
    new_entry = EventEntry.find(event_entries(:complete_event_entry).event_entry_id)
    assert_equal users(:quentin), new_entry.owner_user
    assert_equal event_entries(:complete_event_entry).title,       new_entry.title
    assert_equal event_entries(:complete_event_entry).description, new_entry.description
    assert_equal event_entries(:complete_event_entry).start_date,  new_entry.start_date
    assert_equal event_entries(:complete_event_entry).end_date,    new_entry.end_date
    assert_equal emails(:complete_event_entry).address, new_entry.email.address
#    verify_default_location_fields(new_entry.location)
    assert_equal phone_numbers(:complete_event_entry).number, new_entry.phone_number.number
  end

  def test_should_not_edit_with_missing_location_fields
    login_as :quentin
    put :edit, :id => event_entries(:complete_event_entry).event_entry_id,
      :event_entry => {
        :title            => 'newtitle',
        :description      => 'newdescription',
        :cost             => 'newcost',
        :start_date       => '2006-06-06',
        :end_date         => '2006-06-06'
      },
      :entry => {
        :email => { :address => 'newaddress@contactimprov.org' },
        :location => @@empty_location_fields,
        :phone_number => { :number => '666-666-6666' },
        :ci_url => { :address => 'http://contactimprov.org/newurl/' }
      }
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Country name can.t be blank/, @response.body
#    assert_match /City name can.t be blank/, @response.body
  end

  def test_should_edit_and_disconnect_empty_non_mandatory_fields
    login_as :quentin
    put :edit, :id => event_entries(:complete_event_entry).event_entry_id,
      :event_entry => {
        :title            => 'newtitle',
        :description      => 'newdescription',
        :cost             => 'newcost',
        :start_date       => '2006-06-06',
        :end_date         => '2006-06-06'
      },
      :entry => {
        :email => { :address => '' },
        :location => @@default_location_fields,
        :phone_number => { :number => '' },
        :ci_url => { :address => '' }
      }
    updated_event = EventEntry.find(event_entries(:complete_event_entry).event_entry_id)
    assert_redirected_to :controller => 'events', :action => 'show', :id => updated_event.id
    assert_equal users(:quentin),                    updated_event.owner_user
    assert_equal 'newtitle',                         updated_event.title
    assert_equal 'newdescription',                   updated_event.description
    assert_equal 'newcost',                          updated_event.cost
    assert_equal '2006-06-06',                       updated_event.start_date.strftime('%Y-%m-%d')
    assert_equal '2006-06-06',                       updated_event.end_date.strftime('%Y-%m-%d')
    assert_nil updated_event.email
    verify_default_location_fields(updated_event.location)
    assert_nil updated_event.phone_number
    assert_nil updated_event.url
    assert_equal(1, @emails.size)
    assert_match /Modified Event/, @emails.first.subject
  end

  def test_should_let_owner_user_edit_event_entry_application
    login_as :quentin
    post_data_to_edit_and_test_response
  end

  def test_should_let_admin_edit_event_entry_application
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


  #  Test 'show' action

  def test_should_allow_access_to_show
    get :show, :id => event_entries(:complete_event_entry)
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_no_match /Edit this/, @response.body
  end

  def test_should_show_owner_user_edit_link
    login_as :quentin
    get :show, :id => event_entries(:complete_event_entry)
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /Edit this/, @response.body
  end

  def test_should_show_admin_user_edit_link
    login_as :admin
    get :show, :id => event_entries(:complete_event_entry)
    assert_response :success
    assert_select "[class=errorExplanation]", false
    assert_match /Edit this/, @response.body
  end

  def test_should_display_error_for_show_with_invalid_id
    get :show, :id => 666
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Listing not found/, @response.body
  end


protected

  def post_data_to_edit_and_test_response
    put :edit, :id => event_entries(:complete_event_entry).event_entry_id,
      :event_entry => {
        :title            => 'newtitle',
        :description      => 'newdescription',
        :cost             => 'newcost',
        :start_date       => '2006-06-06',
        :end_date         => '2006-06-06'
      },
      :entry => {
        :email => { :address => 'newaddress@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-666-6666' },
        :ci_url => { :address => 'http://contactimprov.org/newurl/' }
      }
    #  Verify that field values have been updated
    updated_event = EventEntry.find(event_entries(:complete_event_entry).event_entry_id)
    assert_redirected_to :controller => 'events', :action => 'show', :id => updated_event.id
    #  owner_user should not be updated when Contact Event is edited by an admin
    assert_equal users(:quentin),                    updated_event.owner_user
    assert_equal 'newtitle',                         updated_event.title
    assert_equal 'newdescription',                   updated_event.description
    assert_equal 'newcost',                          updated_event.cost
    assert_equal '2006-06-06',                       updated_event.start_date.strftime('%Y-%m-%d')
    assert_equal '2006-06-06',                       updated_event.end_date.strftime('%Y-%m-%d')
    assert_equal 'newaddress@contactimprov.org',     updated_event.email.address
    verify_default_location_fields(updated_event.location)
    assert_equal '666-666-6666',                     updated_event.phone_number.number
    assert_equal 'http://contactimprov.org/newurl/', updated_event.url.address
    assert_equal(1, @emails.size)
    assert_match /Modified Event/, @emails.first.subject
  end

  def verify_error_messages_for_missing_fields
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /End date can.t be blank/, @response.body
    assert_match /Start date can.t be blank/, @response.body
    assert_match /Title can.t be blank/, @response.body
    assert_match /Description can.t be blank/, @response.body
    assert_match /Country name can.t be blank/, @response.body
  end

end
