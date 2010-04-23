require File.dirname(__FILE__) + '/../test_helper'

class ActsAsSettingTest < ActiveSupport::TestCase

  def test_fixtures
    assert Setting.all.count > 3
    assert_equal Setting.find_by_slug('welcome_text').slug, @welcome_text_setting.slug
  end

  def test_validations
    # empty slug
    s = Setting.new(:name => 'Można dodawać spam?', :value => '1')
    assert !s.save
    assert s.errors.invalid?('slug')

    # empty name
    s = Setting.new(:slug => 'spam_allowed', :value => '1')
    assert !s.save
    assert s.errors.invalid?('name')

    # no value
    s = Setting.new(:name => 'Można dodawać spam?', :slug => 'spam_allowed')
    assert !s.save
    assert s.errors.invalid?('value')

    # collision (name)
    s = Setting.new(:name => @welcome_text_setting.name, :slug => 'custom_welcome_text', :value => 'Not so much.')
    assert !s.save
    assert s.errors.invalid?('name')

    # collision (slug)
    s = Setting.new(:name => 'Inny tekst powitalny', :slug => 'welcome_text', :value => 'Not so much.')
    assert !s.save
    assert s.errors.invalid?('slug')
  end

  def test_instance_methods
    assert @registration_allowed_setting.is_boolean?
    assert @welcome_text_setting.is_string?
    assert @news_limit_setting.is_numeric?
  end

  def test_instance_values
    assert_equal @news_limit_setting.instance_value, @news_limit_setting.value.to_i
    assert_equal @registration_allowed_setting.instance_value, true
    assert_equal @welcome_text_setting.instance_value, @welcome_text_setting.value.to_s
  end
end
