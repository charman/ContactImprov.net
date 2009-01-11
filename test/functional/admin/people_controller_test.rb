require 'test_helper'

class Admin::PeopleControllerTest < ActionController::TestCase

  fixtures :person_entries
  

  #  Test 'index' action

  def test_should_allow_admin_access_to_index
    get_page_as_admin_with_no_errors(:index)
  end


  #  Test 'list' action

  def test_should_allow_admin_access_to_list
    get_page_as_admin_with_no_errors(:list)
  end

end
