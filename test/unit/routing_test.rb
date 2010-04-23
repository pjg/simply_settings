require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < ActiveSupport::TestCase

  def test_authentication_routes
    assert_recognition :get, '/ustawienia', :controller => 'settings', :action => 'index'
    assert_recognition :post, '/ustawienia', :controller => 'settings', :action => 'index'
  end

  private

  def assert_recognition(method, path, options)
    result = ActionController::Routing::Routes.recognize_path(path, :method => method)
    assert_equal options, result
  end
end
