module SimplySettings
  module ActsAsSetting
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def acts_as_setting
        send :include, InstanceMethods

        class_eval do
          # Validations
          validates_presence_of :name, :message => 'nazwa nie może być pusta'
          validates_presence_of :slug, :message => 'slug nie może być pusty'
          validates_presence_of :value, :message => 'trzeba wpisać wartość'
          validates_uniqueness_of :name, :message => 'istnieje już takie ustawienie (name)'
          validates_uniqueness_of :slug, :message => 'istnieje już takie ustawienie (slug)'
        end
      end
    end

    module InstanceMethods
      def is_boolean?
        self.slug =~ /enabled$|disabled$|allowed$/ ? true : false
      end

      def is_numeric?
        self.slug =~ /value$|limit$|count$/ ? true : false
      end

      def is_string?
        self.slug =~ /text$/ ? true : false
      end

      def instance_value
        if self.is_boolean?
          return (self.value == '1' or self.value == 'true') ? true : false
        elsif self.is_numeric?
          return self.value.to_i
        elsif self.is_string?
          return self.value.to_s
        else
          # all others (means: multiple settings values selection)
          return self.value
        end
      end
    end
  end
end
