module SimplySettings
  # You can add your own custom settings which will be rendered as multiple options select (when editing)
  # Just put the following into "config/initializers/simply_settings.rb":
  #
  #   SimplySettings::custom_settings[:operating_mode] = {:name => 'Tryb pracy serwisu', :data => {
  #     :normal => 'Normalny',
  #     :easter => 'Wielkanocny',
  #     :christmas => 'Bożonarodzeniowy',
  #     :mourning => 'Żałobny'}}
  #
  @@custom_settings = {}
  mattr_accessor :custom_settings
end
