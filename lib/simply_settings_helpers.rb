module SimplySettings
  module Helpers

    # Hacky dynamic methods based on Boolean settings (like this: registration_allowed?)
    # This is such a big HACK... disgusting
    # It is, however, loaded only ONCE at Class creation (classes are cached in production mode)
    class CustomSetting < ActiveRecord::Base
      set_table_name 'settings'
    end

    CustomSetting.all(:order => 'id').each do |setting|
      if setting.slug =~ /enabled$|disabled$|allowed$/
        define_method "#{setting.slug}?" do
          setting.value == '1' or setting.value == 'true'
        end
      end
    end

    # FILTER (settings are loaded for every page view)
    def load_settings
      @settings = Setting.all(:order => 'id')
      @settings.each do |setting|
        # set instance variables
        instance_variable_set("@#{setting.slug}", setting.instance_value)
      end
    end

    # Method to use in the SettingsController for updating settings
    def edit_or_update_settings
      @title = 'Ustawienia'
      return unless request.post?
      params[:setting].each do |slug, value|
        setting = @settings.detect {|s| s.slug == slug}
        setting.update_attributes(:value => value) if setting
      end
      flash.now[:success] = 'Ustawienia uaktualnione'
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
      flash.now[:error] = 'Wystąpił błąd podczas aktualizacji ustawień'
    end
  end
end
