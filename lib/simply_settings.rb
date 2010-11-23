require 'acts_as_setting'
require 'custom_settings'
require 'simply_settings_helpers'

# acts_as_setting for ActiveRecord's models
ActiveRecord::Base.send :include, SimplySettings::ActsAsSetting

# Helpers will be available in all controllers
ActionController::Base.send :include, SimplySettings::Helpers

# Helpers will be available in all views
ActionView::Base.send :include, SimplySettings::Helpers

# Before filters (will be run for every action in every controller)
ActionController::Base.send :prepend_before_filter, :load_settings
