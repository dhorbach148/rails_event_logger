require "rails_event_logger/user"

module RailsEventLogger
  module Controller
    module CurrentUserExtension
      def self.included(base)
        base.before_filter :set_event_logger_current_user
      end

      def set_event_logger_current_user
        controller = self
        controller.send(RailsEventLogger.current_user_method) if controller.respond_to?(RailsEventLogger.current_user_method)
        RailsEventLogger::User.current = current_user
      end
    end # module CurrentUserExtension
  end # module Controller
end # module RailsEventLogger

if defined?(ActionController) and defined?(ActionController::Base)
  ActionController::Base.send(:include, RailsEventLogger::Controller::CurrentUserExtension)
end
