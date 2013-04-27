module ActiveAdmin
  module BaseController
    module Helpers

      def current_active_admin_user
        send(active_admin_namespace.current_user_method) if active_admin_namespace.current_user_method
      end

      def current_active_admin_user?
        !current_active_admin_user.nil?
      end

      def active_admin_config
        self.class.active_admin_config
      end

      def active_admin_namespace
        active_admin_config.namespace
      end

    end
  end
end
