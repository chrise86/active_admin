require 'active_support/concern'

module ActiveAdmin

  # Adds a class method to a class to create settings with default values.
  #
  # Example:
  #
  #   class Configuration
  #     include ActiveAdmin::Settings
  #
  #     setting :site_title, "Default Site Title"
  #   end
  #
  #   conf = Configuration.new
  #   conf.site_title #=> "Default Site Title"
  #   conf.site_title = "Override Default"
  #   conf.site_title #=> "Override Default"
  #
  module Settings
    extend ActiveSupport::Concern

    def read_default_setting(name)
      default_settings[name]
    end

    private

    def default_settings
      self.class.default_settings
    end

    module ClassMethods

      def setting(name, default)
        default_settings[name] = default
        attr_writer name

        # Create an accessor that looks up the default value if none is set.
        define_method name do
          if instance_variable_defined? "@#{name}"
            instance_variable_get "@#{name}"
          else
            read_default_setting name.to_sym
          end
        end
      end

      def deprecated_setting(name, default, message = nil)
        message = message || "The #{name} setting is deprecated and will be removed."
        setting(name, default)

        ActiveAdmin::Deprecation.deprecate self, name, message
        ActiveAdmin::Deprecation.deprecate self, :"#{name}=", message
      end

      def default_settings
        @default_settings ||= {}
      end

    end
  end
end
