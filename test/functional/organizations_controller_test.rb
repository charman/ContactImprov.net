require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  fixtures :organization_entries, :country_names, :emails, :locations, :people, :phone_numbers, :urls, :us_states, :users


  #  Test 'create' action

  def test_should_create_organization_entry_with_true_flags
    login_as :quentin
    post :create, 
      :organization_entry => {
        :description      => 'newdescription',
      },
      :entry => {
        :organization => { :name => 'newname' },
        :email => { :address => 'newmail@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-333-9999' },
        :ci_url => { :address => 'http://craigharman.net/newurl' }
      },
      :teaches_contact => 'true',
      :studio_space    => 'true'
    new_entry = OrganizationEntry.find(:last)    
    assert_redirected_to :controller => 'organizations', :action => 'show', :id => new_entry.id
    assert_equal users(:quentin),              new_entry.owner_user
    assert_equal 'newdescription',             new_entry.description
    assert_equal 'newname',                    new_entry.organization.name
    assert_equal 'newmail@contactimprov.org',  new_entry.email.address
    verify_default_location_fields(new_entry.location)
    assert_equal '666-333-9999',               new_entry.phone_number.number
    assert_match /craigharman\.net\/newurl/,   new_entry.url.address
    assert_equal true,                         new_entry.teaches_contact
    assert_equal true,                         new_entry.studio_space
  end

  def test_should_create_organization_entry_with_false_flags
    login_as :quentin
    post :create, 
      :organization_entry => {
        :description      => 'newdescription',
      },
      :entry => {
        :organization => { :name => 'newname' },
        :email => { :address => 'newmail@contactimprov.org' },
        :location => @@default_location_fields,
        :phone_number => { :number => '666-333-9999' },
        :ci_url => { :address => 'http://craigharman.net/newurl' }
      },
      :teaches_contact => 'false',
      :studio_space    => 'false'
    new_entry = OrganizationEntry.find(:last)    
    assert_redirected_to :controller => 'organizations', :action => 'show', :id => new_entry.id
    assert_equal users(:quentin),              new_entry.owner_user
    assert_equal 'newdescription',             new_entry.description
    assert_equal 'newname',                    new_entry.organization.name
    assert_equal 'newmail@contactimprov.org',  new_entry.email.address
    verify_default_location_fields(new_entry.location)
    assert_equal '666-333-9999',               new_entry.phone_number.number
    assert_match /craigharman\.net\/newurl/,   new_entry.url.address
    assert_equal false,                        new_entry.teaches_contact
    assert_equal false,                        new_entry.studio_space
  end


  #  Test 'list' action

  def test_should_allow_access_to_list
    get :list
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
