module SimplySettings
  module Helpers

    # custom dynamic methods based on Boolean settings saved in db
    # (we area creating methods like this: registration_allowed? comments_allowed?)
    class CustomSetting < ActiveRecord::Base
      set_table_name 'settings'
    end

    if CustomSetting.table_exists?
      CustomSetting.all(:order => 'id').each do |setting|
        if setting.slug =~ /enabled$|disabled$|allowed$/
          define_method "#{setting.slug}?" do
            setting.value == '1' or setting.value == 'true'
          end
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
      flash.now[:notice] = 'Ustawienia uaktualnione'
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
      flash.now[:alert] = 'Wystąpił błąd podczas aktualizacji ustawień'
    end
  end
end
