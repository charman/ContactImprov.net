require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  #  Test 'activate' action
  
  def test_should_activate_user
    login_as :admin
    assert_equal 'pending', users(:pending_user).state
    post :activate, :id => users(:pending_user),
                    :user => { :email => 'activate@contactquarterly.com', 
                               :password => 'test', 
                               :password_confirmation => 'test' }
    assert_redirected_to :action => 'index'
    assert_select "[class=errorExplanation]", false
    users(:pending_user).reload
    assert_equal 'active', users(:pending_user).state
    assert_equal 1, @emails.size
  end
  
  def test_should_not_activate_user_with_mismatched_passwords
    login_as :admin
    post :activate, :id => users(:pending_user),
                    :user => { :email => 'activate@contactquarterly.com', 
                               :password => 'test', 
                               :password_confirmation => 'mismatched' }
    #  We're not really testing for 'success' here, but rather if the form has been redisplayed
    assert_response :success
    assert_select "[class=errorExplanation]"
    users(:pending_user).reload
    assert_equal 'pending', users(:pending_user).state
    assert_equal 0, @emails.size
  end


  #  Test 'create' action
  
  def test_should_create_user
    login_as :admin
    post :create, :user => { :email => 'admin_users_create@contactquarterly.com', 
                             :password => 'test', 
                             :password_confirmation => 'test',
                             :person => { :first_name => 'Firstname',
                                          :last_name => 'Lastname' } 
                           }
    assert_redirected_to :action => 'index'
    assert_select "[class=errorExplanation]", false
    user = User.find_by_email('admin_users_create@contactquarterly.com')
    assert_not_nil user
    assert_equal 'pending', user.state
    assert_equal(1, @emails.size)
  end
  
  def test_should_not_create_user_without_last_name
    login_as :admin
    post :create, :user => { :email => 'admin_users_create@contactquarterly.com', 
                             :password => 'test', 
                             :password_confirmation => 'test' }
    #  We're not really testing for 'success' here, but rather if the form has been redisplayed
    assert_response :success
    assert_select "[class=errorExplanation]"
    user = User.find_by_email('admin_users_create@contactquarterly.com')
    assert_nil user
    assert_equal(0, @emails.size)
  end
  
  def test_should_not_create_user_with_mismatched_passwords
    login_as :admin
    post :create, :user => { :email => 'admin_users_create@contactquarterly.com', 
                             :password => 'test', 
                             :password_confirmation => 'mismatched' }
    #  We're not really testing for 'success' here, but rather if the form has been redisplayed
    assert_response :success
    assert_select "[class=errorExplanation]"
    user = User.find_by_email('admin_users_create@contactquarterly.com')
    assert_nil user
    assert_equal(0, @emails.size)
  end
  
  
  #  Test 'edit' action
  
  #  Most of these tests were copied over from the functional tests for /user, but
  #   with these two changes:
  #     - login_as always uses :admin, instead of the username
  #     - we need to provide an extra :id parameter when PUT/GET'ing the page

  def test_should_allow_admin_access_to_edit
    login_as :admin
    get :edit, :id => users(:quentin).id
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

  # def test_should_email_admin_when_user_edits_address
  #   login_as :admin
  #   #  Save current address to the database.  We want to compare the previous version of the address
  #   #   to the new version of the address.  This comparison is between two versions of the address
  #   #   *in the database*.  When we access an object using a fixture (e.g. users(:quentin)), the
  #   #   fixture data is loaded into memory - but has not necessarily been saved to the database.
  #   #   If another test used the same "new address" that we are supplying in the POST request,
  #   #   then the "new address" won't differ from the "old address" (which was saved by another
  #   #   test).  Saving the fixture data to the database ensures that we are using the correct
  #   #   "old address".
  #   assert users(:quentin).subscriber_address.save!
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'Pennsylvania'}, 
  #                                                :country_name => {:english_name => 'United States'}}}
  #   users(:quentin).reload
  #   users(:quentin).subscriber_address.reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:quentin).person.first_name, 'new_first'
  #   assert_equal users(:quentin).person.last_name, 'new_last'
  #   assert_equal users(:quentin).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:quentin).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:quentin).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:quentin).subscriber_address.postal_code, '60606'
  #   assert_equal users(:quentin).subscriber_address.us_state.abbreviation, 'PA'
  #   assert_equal users(:quentin).subscriber_address.country_name.iso_3166_1_a2_code, 'US'
  #   assert_equal(1, @emails.size)
  #   assert_match(/NEW ADDRESS/, @emails.first.body)
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_us_to_us_user
  #   login_as :admin
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'Pennsylvania'}, 
  #                                                :country_name => {:english_name => 'United States'}}}
  #   users(:quentin).reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:quentin).person.first_name, 'new_first'
  #   assert_equal users(:quentin).person.last_name, 'new_last'
  #   assert_equal users(:quentin).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:quentin).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:quentin).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:quentin).subscriber_address.postal_code, '60606'
  #   assert_equal users(:quentin).subscriber_address.us_state.abbreviation, 'PA'
  #   assert_equal users(:quentin).subscriber_address.country_name.iso_3166_1_a2_code, 'US'
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_us_to_us_user_with_usa_for_country_name
  #   login_as :admin
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'pa'}, 
  #                                                :country_name => {:english_name => ' usa '}}}
  #   users(:quentin).reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:quentin).person.first_name, 'new_first'
  #   assert_equal users(:quentin).person.last_name, 'new_last'
  #   assert_equal users(:quentin).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:quentin).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:quentin).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:quentin).subscriber_address.postal_code, '60606'
  #   assert_equal users(:quentin).subscriber_address.us_state.abbreviation, 'PA'
  #   assert_equal users(:quentin).subscriber_address.country_name.iso_3166_1_a2_code, 'US'
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_us_to_us_user_with_state_abbreviation
  #   login_as :admin
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'pa'}, 
  #                                                :country_name => {:english_name => 'United States'}}}
  #   users(:quentin).reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:quentin).person.first_name, 'new_first'
  #   assert_equal users(:quentin).person.last_name, 'new_last'
  #   assert_equal users(:quentin).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:quentin).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:quentin).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:quentin).subscriber_address.postal_code, '60606'
  #   assert_equal users(:quentin).subscriber_address.us_state.abbreviation, 'PA'
  #   assert_equal users(:quentin).subscriber_address.country_name.iso_3166_1_a2_code, 'US'
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_us_to_foreign_user
  #   login_as :admin
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'Ontario'}, 
  #                                                :country_name => {:english_name => 'Canada'}}}
  #   users(:quentin).reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:quentin).person.first_name, 'new_first'
  #   assert_equal users(:quentin).person.last_name, 'new_last'
  #   assert_equal users(:quentin).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:quentin).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:quentin).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:quentin).subscriber_address.postal_code, '60606'
  #   assert_equal users(:quentin).subscriber_address.region_name, 'Ontario'
  #   assert_equal users(:quentin).subscriber_address.country_name.iso_3166_1_a2_code, 'CA'
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_foreign_to_us_user
  #   login_as :admin
  #   put :edit, :id => users(:aaron).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'New York'}, 
  #                                                :country_name => {:english_name => 'United States'}}}
  #   users(:aaron).reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:aaron).person.first_name, 'new_first'
  #   assert_equal users(:aaron).person.last_name, 'new_last'
  #   assert_equal users(:aaron).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:aaron).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:aaron).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:aaron).subscriber_address.postal_code, '60606'
  #   assert_equal users(:aaron).subscriber_address.us_state.abbreviation, 'NY'
  #   assert_equal users(:aaron).subscriber_address.country_name.iso_3166_1_a2_code, 'US'
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_user_with_england_for_country_name
  #   login_as :admin
  #   put :edit, :id => users(:aaron).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => ''}, 
  #                                                :country_name => {:english_name => ' england '}}}
  #   users(:aaron).reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal users(:aaron).person.first_name, 'new_first'
  #   assert_equal users(:aaron).person.last_name, 'new_last'
  #   assert_equal users(:aaron).subscriber_address.street_address_line_1, 'new_line_1' 
  #   assert_equal users(:aaron).subscriber_address.street_address_line_2, 'new_line_2' 
  #   assert_equal users(:aaron).subscriber_address.city_name, 'new_city'
  #   assert_equal users(:aaron).subscriber_address.postal_code, '60606'
  #   assert_equal users(:aaron).subscriber_address.country_name.iso_3166_1_a2_code, 'GB'
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_not_edit_with_unknown_country_name
  #   login_as :admin
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'Ontario'}, 
  #                                                :country_name => {:english_name => 'UnknownCountry'}}}
  #   users(:quentin).reload
  #   assert_select "[class=errorExplanation]"
  #   assert_match /is not the name of a country in our database/, @response.body
  #   assert_match /UnknownCountry/, @response.body
  #   #  Verify that the view displays a select control (and not an input control) when the user provided an invalid country name
  #   #   incorrect country name
  #   assert_select "select#country_name_english_name"
  #   #  We're not really testing for 'success' here, but rather if the form has been redisplayed
  #   assert_response :success
  # end
  # 
  # def test_should_not_edit_us_with_unknown_state
  #   login_as :admin
  #   put :edit, :id => users(:quentin).id,
  #              :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
  #                        :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'UnknownState'}, 
  #                                                :country_name => {:english_name => 'United States'}}}
  #   users(:quentin).reload
  #   assert_select "[class=errorExplanation]"
  #   assert_match /is not the name of a US state/, @response.body
  #   assert_match /UnknownState/, @response.body
  #   #  Verify that the view displays an input control (and not a select control) when the user provided a valid country name
  #   assert_select "input[id$=country_name_english_name]"
  #   #  We're not really testing for 'success' here, but rather if the form has been redisplayed
  #   assert_response :success
  # end

  def test_should_not_edit_with_empty_last_name
    login_as :admin
    put :edit, :id => users(:quentin).id,
               :user => {:person => {:first_name => '', :last_name => ''},
                         :subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
                                                 :city_name => 'new_city', :postal_code => '60606',
                                                 :us_state => {:name => 'pa'}, 
                                                 :country_name => {:english_name => 'United States'}}}
    users(:quentin).reload
    assert_select "[class=errorExplanation]"
    assert_match /Last name can.{1,10}t be blank/, @response.body
    #  We're not really testing for 'success' here, but rather if the form has been redisplayed
    assert_response :success
  end
  

  #  Test 'index' action

  def test_should_allow_admin_access_to_index
    get_page_as_admin_with_no_errors(:index)
  end


  #  Test 'list' action

  def test_should_allow_admin_access_to_list
    get_page_as_admin_with_no_errors(:list)
  end


  #  Test 'list_active' action

  def test_should_allow_admin_access_to_list_active
    get_page_as_admin_with_no_errors(:list_active)
  end


  #  Test 'list_pending' action

  def test_should_allow_admin_access_to_list_pending
    get_page_as_admin_with_no_errors(:list_pending)
  end


  #  Test 'map' action

  def test_should_allow_admin_access_to_map
    get_page_as_admin_with_no_errors(:map)
  end


  #  Test 'new' action

  def test_should_allow_admin_access_to_new
    get_page_as_admin_with_no_errors(:new)
  end


  #  Test 'reset_password' action

  def test_should_allow_admin_access_to_reset_password
    login_as :admin
    get :reset_password, :id => users(:quentin).id
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

  def test_should_reset_password
    login_as :admin
    assert users(:quentin).valid_password?('test')
    post :reset_password, :id => users(:quentin).id, :user => {:password => 'new_password', :password_confirmation => 'new_password'}
    assert_redirected_to :action => 'show', :id => users(:quentin).id
    users(:quentin).reload
    assert_select "[class=errorExplanation]", false
    assert users(:quentin).valid_password?('new_password')
    assert !users(:quentin).valid_password?('test')
    assert_equal 1, @emails.size
    assert_match 'new_password', @emails.first.body
    assert_match 'New password for your ContactImprov.net account', @emails.first.subject
  end

  def test_should_not_reset_password_with_mismatched_passwords
    login_as :admin
    assert users(:quentin).valid_password?('test')
    post :reset_password, :id => users(:quentin).id, :user => {:password => 'new_password', :password_confirmation => 'bad_password'}
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert users(:quentin).valid_password?('test')
    assert !users(:quentin).valid_password?('new_password')
    assert_equal 0, @emails.size
  end


  #  Test 'show' action

  def test_should_allow_admin_access_to_show
    login_as :admin
    get :show, :id => users(:quentin).user_id
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end


  # TODO: Test 'suspend' action
  # TODO: Test 'unsuspend' action
  # TODO: Test 'destroy' action
  # TODO: Test 'purge' action

end
