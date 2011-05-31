require 'test_helper'
require 'rack/test'


class ExceptionNotifierTest < Test::Unit::TestCase

  include Rack::Test::Methods

  def app
    ContactImprovNet::Application
  end


  #  Test 'exception_test' action

  def test_should_raise_exception
    get '/admin/home/exception_test'
    assert_match /Action Controller: Exception caught/, last_response.body
    assert rack_mock_session.last_request.env['exception_notifier.delivered']
  end

end
