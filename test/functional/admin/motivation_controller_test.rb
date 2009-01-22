require 'test_helper'

class Admin::MotivationControllerTest < ActionController::TestCase

  #  Test 'index' action

  def test_should_allow_admin_access_to_index
    get_page_as_admin_with_no_errors(:index)
  end

end
