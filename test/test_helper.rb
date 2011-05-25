ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  #  [CTH]  We are using MySQL with MyISAM tables, so we set use_transactional_fixtures to false
  ## self.use_transactional_fixtures = true
  self.use_transactional_fixtures = false

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

#  # Add more helper methods to be used by all tests here...
#  include AuthenticatedTestHelper

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  @@default_location_fields = {:street_address_line_1 => 'new_address_1',
                               :street_address_line_2 => 'new_address_2',
                               :city_name => 'new_city',
                               :postal_code => '12345',
                               :us_state => {:name => 'new_region'},
                               :country_name => {:english_name => 'Canada'}}
  @@empty_location_fields = {:street_address_line_1 => '',
                             :street_address_line_2 => '',
                             :city_name => '',
                             :postal_code => '',
                             :us_state => {:name => ''},
                             :country_name => {:english_name => ''}}
end


def get_page_as_admin_with_no_errors(page)
  login_as :admin
  get page
  assert_response :success
  assert_select "[class=errorExplanation]", false
end


def verify_default_location_fields(location)
  assert_equal 'new_address_1', location.street_address_line_1
  assert_equal 'new_address_2', location.street_address_line_2
  assert_equal 'new_city', location.city_name
  assert_equal '12345', location.postal_code
  assert_equal 'new_region', location.state_name_or_region_name
  assert_equal 'Canada', location.english_country_name
end
