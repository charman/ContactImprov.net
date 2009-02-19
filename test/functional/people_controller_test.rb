require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  fixtures :person_entries, :country_names, :emails, :locations, :people, :phone_numbers, :urls, :us_states, :users


  #  Test 'create' action

  def test_should_accept_person_entry_application_for_teacher
    login_as :quentin
    post :create, 
      :person_entry => {
        :description      => 'newdescription',
      },
      :entry => {
        :person => { 
          :first_name => 'newfirstname', 
          :last_name  => 'newlastname'
        },
        :email => { :address => 'newmail@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-333-9999' },
        :ci_url => { :address => 'http://craigharman.net/newurl' }
      },
      :teaches_contact => 'true'
    assert_redirected_to :action => 'show'
    new_entry = PersonEntry.find(:last)    
    assert_equal users(:quentin),              new_entry.owner_user
    assert_equal 'newdescription',             new_entry.description
    assert_equal 'newfirstname',               new_entry.person.first_name
    assert_equal 'newlastname',                new_entry.person.last_name
    assert_equal 'newmail@contactimprov.org',  new_entry.email.address
    verify_default_location_fields(new_entry.location)
    assert_equal '666-333-9999',               new_entry.phone_number.number
    assert_match /craigharman\.net\/newurl/,   new_entry.url.address
    assert_equal true,                         new_entry.teaches_contact
  end

  def test_should_accept_person_entry_application_for_non_teacher
    login_as :quentin
    post :create, 
      :person_entry => {
        :description      => 'newdescription',
      },
      :entry => {
        :person => { 
          :first_name => 'newfirstname', 
          :last_name  => 'newlastname'
        },
        :email => { :address => 'newmail@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-333-9999' },
        :ci_url => { :address => 'http://craigharman.net/newurl' }
      },
      :teaches_contact => 'false'
    assert_redirected_to :action => 'show'
    new_entry = PersonEntry.find(:last)    
    assert_equal false,                        new_entry.teaches_contact
  end


  #  Test 'list' action

  def test_should_allow_access_to_list
    get :list
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
