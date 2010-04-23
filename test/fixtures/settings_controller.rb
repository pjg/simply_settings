class SettingsController < ApplicationController
  layout 'test'

  skip_filter filter_chain
  prepend_before_filter :load_settings

  def index
    edit_or_update_settings
  end
end
