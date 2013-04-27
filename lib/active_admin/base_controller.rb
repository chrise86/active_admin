require 'active_admin/base_controller/authorization'
require 'active_admin/base_controller/menu'
require 'active_admin/base_controller/helpers'

module ActiveAdmin
  module BaseController
    extend ActiveSupport::Concern

    included do
      inherit_resources

      helper ActiveAdmin::ViewHelpers
      helper Helpers

      layout :determine_active_admin_layout

      before_filter :only_render_implemented_actions
      before_filter :authenticate_active_admin_user

      include Menu
      include Authorization
      include Helpers
    end

    module ClassMethods
      # Ensure this method is available for the DSL
      public :actions

      # the Resource/Page that initialized this controller
      attr_accessor :active_admin_config
    end

    module InstanceMethods
      # Calls the authentication method as defined in ActiveAdmin.authentication_method
      def authenticate_active_admin_user
        send(active_admin_namespace.authentication_method) if active_admin_namespace.authentication_method
      end

      ACTIVE_ADMIN_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]

      # Determine which layout to use.
      #
      #   1.  If we're rendering a standard Active Admin action, we want layout(false)
      #       because these actions are subclasses of the Base page (which implements
      #       all the required layout code)
      #   2.  If we're rendering a custom action, we'll use the active_admin layout so
      #       that users can render any template inside Active Admin.
      def determine_active_admin_layout
        ACTIVE_ADMIN_ACTIONS.include?(params[:action].to_sym) ? false : 'active_admin'
      end

      # By default Rails will render un-implemented actions when the view exists. Becuase Active
      # Admin allows you to not render any of the actions by using the #actions method, we need
      # to check if they are implemented.
      def only_render_implemented_actions
        raise AbstractController::ActionNotFound unless action_methods.include?(params[:action])
      end
    end
  end
end
