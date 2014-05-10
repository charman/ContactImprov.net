require 'test_helper'

class UserControllerTest < ActionController::TestCase

  #  Test 'activate' action

  def test_should_show_form_with_activation_code
    assert users(:passive_user).register!
    users(:passive_user).reload
    assert users(:passive_user).pending?
    get :activate, :activation_code => users(:passive_user).activation_code
    users(:passive_user).reload
    assert_select "[class=errorExplanation]", false
    assert_response :success
  end

  def test_should_not_show_form_with_invalid_activation_code
    get :activate, :activation_code => 'randomgarbage'
    assert_select "[class=errorExplanation]"
    assert_response :success
  end

  def test_should_activate_pending_user_with_activation_code
    assert users(:passive_user).passive?
    assert users(:passive_user).register!
    users(:passive_user).reload
    assert users(:passive_user).pending?
    post :activate, :activation_code => users(:passive_user).activation_code, 
      :user => { :password => 'new_password', :password_confirmation => 'new_password'}
    users(:passive_user).reload
    assert users(:passive_user).active?
    assert_redirected_to :action => 'index'
  end

  def test_should_not_activate_pending_user_with_activation_code_but_mismatched_passwords
    assert users(:passive_user).passive?
    assert users(:passive_user).register!
    users(:passive_user).reload
    assert users(:passive_user).pending?
    post :activate, :activation_code => users(:passive_user).activation_code, 
      :user => { :password => 'new_password', :password_confirmation => 'different_password'}
    users(:passive_user).reload
    assert users(:passive_user).pending?
    assert_select "[class=errorExplanation]"
    assert_response :success
  end


  #  Test 'change_email' action

  def test_should_change_email
    login_as :quentin
    post :change_email, :password => 'test', :email => 'new_email@contactimprov.org', 
         :email_confirmation => 'new_email@contactimprov.org'
    users(:quentin).reload
    assert_equal users(:quentin).email, 'new_email@contactimprov.org'
    assert_select "[id=change_successful]"
    assert_response :success
    assert_equal(1, @emails.size)
    assert_match /EMAIL CHANGED/, @emails.first.body
    assert_match /Your email address has been changed/, @response.body
    assert_select "[class=errorExplanation]", false
  end

  def test_should_not_change_email_with_bad_password
    login_as :quentin
    post :change_email, :password => 'badpassword', :email => 'new_email@contactimprov.org', 
         :email_confirmation => 'new_email@contactimprov.org'
    assert_select "[class=errorExplanation]"
    assert_match /Old password incorrect/, @response.body
    users(:quentin).reload
    assert_not_equal users(:quentin).email, 'new_email@contactimprov.org'
  end

  def test_should_not_change_email_with_bad_email
    login_as :quentin
    post :change_email, :password => 'test', :email => 'new_email-contactimprov.org', 
         :email_confirmation => 'new_email-contactimprov.org'
    assert_select "[class=errorExplanation]"
    assert_match /Email does not appear to be valid/, @response.body
    users(:quentin).reload
    assert_not_equal users(:quentin).email, 'new_email@contactimprov.org'
  end

  def test_should_not_change_email_with_mismatched_emails
    login_as :quentin
    post :change_email, :password => 'test', :email => 'new_email@contactimprov.org', 
         :email_confirmation => 'different@contactimprov.org'
    assert_select "[class=errorExplanation]"
    assert_match /email addresses do not match/, @response.body
    users(:quentin).reload
    assert_not_equal users(:quentin).email, 'new_email@contactimprov.org'
  end


  #  Test 'change_password' action

  def test_should_not_change_password_with_mismatched_passwords
    login_as :quentin
    post :change_password, :old_password => 'test', :password => 'password', :password_confirmation => 'mismatched'
    assert_select "[class=errorExplanation]"
    assert_match /Password doesn.{1,6}t match confirmation/, @response.body
    assert_match /The password must have at least four characters/, @response.body
    assert_response :success
  end

  def test_should_not_change_password_with_bad_password
    login_as :quentin
    post :change_password, :old_password => 'bad_password', :password => 'password', :password_confirmation => 'mismatched'
    assert_select "[class=errorExplanation]"
    assert_match /Incorrect old password/, @response.body
    assert_response :success
  end

  def test_should_change_password
    login_as :quentin
    post :change_password, :old_password => 'test', :password => 'new_password', :password_confirmation => 'new_password'
    users(:quentin).reload
    assert users(:quentin).valid_password?('new_password')
    assert_select "[id=change_successful]"
    assert_select "[class=errorExplanation]", false
    assert_response :success
  end


  #  Test 'edit' action

  # def test_should_email_admin_with_name_in_subject_when_user_edits_address_but_not_name
  #   login_as :only_used_once_user
  #   #  TODO: Figure out the strange fixture/version interactions.
  #   #        When we create a new Location from a script/console, a version is saved as
  #   #         soon as the Location instance is saved.  But when we call save on a Location
  #   #         instance (subscriber_address) here, a new version is not saved.  I'm assuming
  #   #         that 
  #   assert users(:only_used_once_user).subscriber_address.save!
  #   users(:only_used_once_user).subscriber_address.city_name = 'force save second version'
  #   assert users(:only_used_once_user).subscriber_address.save!
  #   put :edit, :user =>  {:subscriber_address => {:street_address_line_1 => 'new_line_1', :street_address_line_2 => 'new_line_2', 
  #                                                :city_name => 'new_city', :postal_code => '60606',
  #                                                :us_state => {:name => 'Pennsylvania'}, 
  #                                                :country_name => {:english_name => 'United States'}}}
  #   users(:only_used_once_user).reload
  #   users(:only_used_once_user).subscriber_address.reload
  #   assert_redirected_to :action => 'index'
  #   assert_equal 'new_line_1', users(:only_used_once_user).subscriber_address.street_address_line_1
  #   assert_equal 'new_line_2', users(:only_used_once_user).subscriber_address.street_address_line_2 
  #   assert_equal 'new_city', users(:only_used_once_user).subscriber_address.city_name
  #   assert_equal '60606', users(:only_used_once_user).subscriber_address.postal_code
  #   assert_equal 'PA', users(:only_used_once_user).subscriber_address.us_state.abbreviation
  #   assert_equal 'US', users(:only_used_once_user).subscriber_address.country_name.iso_3166_1_a2_code
  #   assert_equal 1, @emails.size
  #   assert_match /#{users(:only_used_once_user).person.first_name}/, @emails.first.header["subject"].body
  #   assert_match /#{users(:only_used_once_user).person.last_name}/, @emails.first.header["subject"].body
  #   assert_match /NEW ADDRESS/, @emails.first.body
  #   assert_select "[class=errorExplanation]", false
  # end
  # 
  # def test_should_edit_us_to_us_user
  #   login_as :quentin
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :quentin
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :quentin
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :quentin
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :aaron
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :aaron
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :quentin
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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
  #   login_as :quentin
  #   put :edit, :user => {:person => {:first_name => 'new_first', :last_name => 'new_last'},
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

  def test_should_edit_user
    login_as :quentin
    put :edit, :user => {:person => {:first_name => 'newfirst', :last_name => 'newlast'}}
    users(:quentin).reload
    assert_redirected_to :action => 'index'
    assert_equal 'newfirst', users(:quentin).person.first_name
    assert_equal 'newlast',  users(:quentin).person.last_name
    assert_select "[class=errorExplanation]", false
  end

  def test_should_not_edit_with_empty_last_name
    login_as :quentin
    put :edit, :user => {:person => {:first_name => '', :last_name => ''}}
    users(:quentin).reload
    assert_select "[class=errorExplanation]"
    assert_match /Last name can.{1,10}t be blank/, @response.body
    assert_response :success
  end


  #  Test 'index' action

  def test_should_allow_logged_on_user_to_access_index
    login_as :quentin
    get :index
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

  def test_should_not_allow_access_to_index_without_login
    get :index
    assert_redirected_to new_session_path
  end


  #  Test 'request_account' action

  def test_should_not_allow_request_account_with_empty_something_about_contact_improv
    post :request_account, 
         :user_account_request => { 
           :something_about_contact_improv => '', 
           :existing_entries => 'notapplicable' 
          },
         :uar_person => { :first_name => 'first_name', :last_name => 'last_name' },
         :uar_email => { :address => 'new_email@foo.com' }
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Something about contact improv can.{1,6}t be blank/, @response.body
  end
  
  def test_should_not_allow_request_account_with_empty_last_name
    post :request_account, 
         :user_account_request => { 
           :something_about_contact_improv => 'something', 
           :existing_entries => 'notapplicable' 
          },
         :uar_person => { :first_name => 'first_name', :last_name => '' },
         :uar_email => { :address => 'new_email@foo.com' }
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Last name can.{1,9}t be blank/, @response.body
  end
  
  def test_should_not_allow_request_account_with_empty_email
    post :request_account,
         :user_account_request => { 
           :something_about_contact_improv => 'something', 
           :existing_entries => 'notapplicable' 
          },
         :uar_person => { :first_name => 'first_name', :last_name => 'last_name' },
         :uar_email => { :address => '' }
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /Address can.{1,6}t be blank/, @response.body
  end

  def test_should_not_allow_request_account_with_invalid_email
    post :request_account,
         :user_account_request => { 
           :something_about_contact_improv => 'something', 
           :existing_entries => 'notapplicable' 
          },
         :uar_person => { :first_name => 'first_name', :last_name => 'last_name' },
         :uar_email => { :address => 'invalid' }
    assert_response :success
    assert_select "[class=errorExplanation]"
    assert_match /does not appear to be valid/, @response.body
  end

  def test_should_allow_request_account
    post :request_account, 
          :user_account_request => { 
            :something_about_contact_improv => 'something', 
            :existing_entries => 'notapplicable' 
           },
         :uar_person => { :first_name => 'first_name', :last_name => 'last_name' },
         :uar_email => { :address => 'new_email@foo.com' }
    assert_redirected_to :action => 'account_requested'
  
    uar = UserAccountRequest.find(:last)
    assert_not_nil uar
    assert_equal 'something', uar.something_about_contact_improv
    assert_equal 'notapplicable', uar.existing_entries
    assert_equal 'first_name', uar.person.first_name
    assert_equal 'last_name',  uar.person.last_name
    assert_equal 'new_email@foo.com', uar.email.address
  
    assert_equal(1, @emails.size)
    assert_match /ACCOUNT REQUEST/, @emails.first.body
  end

  def test_should_send_pending_users_activation_email_when_they_request_account
   post :request_account, 
        :user_account_request => { 
          :something_about_contact_improv => 'something', 
          :existing_entries => 'notapplicable' 
         },
        :uar_person => { :first_name => 'first_name', :last_name => 'last_name' },
        :uar_email => { :address => users(:pending_user).email }
   assert_response :success
   assert_select "[class=errorExplanation]"
   assert_match /You need to activate your account/, @response.body
   assert_equal(1, @emails.size)
   assert_match /We have created a ContactImprov.net account for you/, @emails.first.subject
   assert_match /A ContactImprov.net account has been created for you/, @emails.first.body
  end

  def test_should_send_active_users_password_reset_email_when_they_request_account
    post :request_account, 
         :user_account_request => { 
           :something_about_contact_improv => 'something', 
           :existing_entries => 'notapplicable' 
          },
         :uar_person => { :first_name => 'first_name', :last_name => 'last_name' },
         :uar_email => { :address => users(:quentin).email }
    assert_redirected_to :action => 'password_reset_requested'
    assert_select "[class=errorExplanation]", false
    assert_equal(1, @emails.size)
    assert_match /Instructions for resetting your ContactImprov.net account password/, @emails.first.subject
    assert_match /We have received a request to reset the password/, @emails.first.body
  end


  #  Test 'request_password_reset' action

  def test_should_not_allow_request_password_reset_with_empty_email
    post :request_password_reset, :email => ''
    assert_response :success
    assert flash[:notice]
    assert_match /You must provide an email address/, @response.body
  end

  def test_should_not_allow_request_password_reset_with_mismatched_emails
    post :request_password_reset, :email => 'quentin@contactimprov.org', :email_confirmation => 'notquentin@contactimprov.org'
    assert_response :success
    assert flash[:notice]
    assert_match /The email addresses you provided do not match/, @response.body
  end

  def test_should_not_allow_request_password_for_unknown_email
    post :request_password_reset, :email => 'unknown_user@contactimprov.org', :email_confirmation => 'unknown_user@contactimprov.org'
    assert_response :success
    assert flash[:notice]
    assert_match /We don.t seem to have any records of a user with the email address/, @response.body
  end

  def test_should_not_allow_request_password_for_pending_user
    post :request_password_reset, :email => 'aaron@contactimprov.org', :email_confirmation => 'aaron@contactimprov.org'
    assert_response :success
    assert flash[:notice]
    assert_match /You need to activate your account/, @response.body
    assert_equal(1, @emails.size)
    #  TODO: Test values of the email subject, recipient, and body
  end

  def test_should_not_allow_request_password_for_passive_user
    post :request_password_reset, :email => 'passive_user@contactimprov.org', :email_confirmation => 'passive_user@contactimprov.org'
    assert_response :success
    assert flash[:notice]
    assert_match /Your account is not set up yet/, @response.body
    assert_equal(1, @emails.size)
    #  TODO: Test values of the email subject, recipient, and body
  end

  def test_should_allow_request_password
    post :request_password_reset, :email => 'quentin@contactimprov.org', :email_confirmation => 'quentin@contactimprov.org'
    assert_redirected_to :action => 'password_reset_requested' 
    assert_select "[class=errorExplanation]", false
  end


  #  Test 'reset_password' action

  def test_should_find_user_to_reset_password_for
    code = users(:quentin).make_password_reset_code
    get :reset_password, :password_reset_code => code
    assert_select "#password_reset_form"
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

  def test_should_not_find_user_to_reset_password_for_with_get
    get :reset_password, :password_reset_code => ''
    assert_select "#password_reset_form", false
    assert_response :success
    assert_match /Invalid password reset code/, @response.body
    assert_equal(1, @emails.size)
    assert_match /Invalid password reset code/, @emails.first.subject
  end

  def test_should_not_find_user_to_reset_password_for_with_post
    post :reset_password, :password_reset_code => ''
    assert_select "#password_reset_form", false
    assert_response :success
    assert_match /Invalid password reset code/, @response.body
    assert_equal(1, @emails.size)
    assert_match /Invalid password reset code/, @emails.first.subject
  end

  def test_should_not_reset_password_with_mismatched_passwords
    code = users(:quentin).make_password_reset_code
    post :reset_password, :password_reset_code => code, :user => { :password => 'password', :password_confirmation => 'mismatched'}
    assert_select "[class=errorExplanation]"
    assert_response :success
    assert_match /Password doesn.{1,6}t match confirmation/, @response.body
  end

  def test_should_reset_password
    code = users(:quentin).make_password_reset_code
    post :reset_password, :password_reset_code => code, :user => { :password => 'new_password', :password_confirmation => 'new_password'}
    users(:quentin).reload
    assert users(:quentin).valid_password?('new_password')
    assert_nil users(:quentin).password_reset_code
    assert_select "[id=reset_successful]"
    assert_response :success
    assert_select "[class=errorExplanation]", false
  end

end
