module ActiveAdmin
  module Callbacks
    extend ActiveSupport::Concern

    protected

    # Simple callback system. Implements before and after callbacks for
    # use within the controllers.
    #
    # We didn't use the ActiveSupport callbacks becuase they do not support
    # passing in any arbitrary object into the callback method (which we
    # need to do)

    def run_callback(method, *args)
      case method
      when Symbol
        send(method, *args)
      when Proc
        instance_exec(*args, &method)
      else
        raise "Please register with callbacks using a symbol or a block/proc."
      end
    end

    module ClassMethods

      # Define a new callback.
      #
      # Example:
      #
      #   class MyClassWithCallbacks
      #     include ActiveAdmin::Callbacks
      #
      #     define_active_admin_callbacks :save
      #
      #     before_save do |arg1, arg2|
      #       # runs before save
      #     end
      #
      #     after_save :call_after_save
      #
      #     def save
      #       # Will run before, yield, then after
      #       run_save_callbacks :arg1, :arg2 do
      #         save!
      #       end
      #     end
      #
      #     protected
      #
      #     def call_after_save(arg1, arg2)
      #       # runs after save
      #     end
      #   end
      #
      def define_active_admin_callbacks(*names)
        names.each do |name|
          [:before, :after].each do |type|

            # def self.before_create_callbacks
            collection_name = "#{type}_#{name}_callbacks"
            singleton_class.send :define_method, collection_name do
              instance_variable_get("@#{collection_name}") || instance_variable_set("@#{collection_name}", [])
            end

            # def self.before_create
            singleton_class.send :define_method, "#{type}_#{name}" do |method = nil, &block|
              send("#{type}_#{name}_callbacks").push method || block
            end
          end

          # def run_create_callbacks
          define_method "run_#{name}_callbacks" do |*args, &block|
            self.class.send("before_#{name}_callbacks").each{ |cbk| run_callback(cbk, *args) }
            value = block.try :call
            self.class.send("after_#{name}_callbacks").each { |cbk| run_callback(cbk, *args) }
            return value
          end
        end
      end
    end
  end
end
