require File.dirname(__FILE__) + '/../test_helper'
require 'action_controller'
require 'action_controller/test_process'

require File.dirname(__FILE__) + '/../fixtures/settings_controller.rb'

class SettingsControllerTest < ActionController::TestCase

  include SimplySettings::Helpers

  def setup
    @controller = SettingsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @request.host = 'localhost'

    # have to be loaded here because @settings variable is overwritten by the settings.yml fixtures
    load_settings
  end

  def test_settings_as_instance_variables
    assert_equal @settings.count, Setting.count
    assert_equal @welcome_text_setting.value, @welcome_text
    assert @registration_allowed
    assert @password_change_allowed
  end

  def test_helper_methods
    assert registration_allowed?
    assert password_change_allowed?
  end

  def test_settings_page
    get :index
    assert_select "input[type=text]#setting_welcome_text"
  end

  def test_updating_settings
    old_limit = @news_limit
    new_limit = 23
    post :index, {:setting => {:news_limit => new_limit.to_s}}
    assert_response :success
    assert flash.has_key?(:notice)
    assert_equal new_limit, Setting.find_by_slug('news_limit').value.to_i
  end
end
