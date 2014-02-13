require "rails_event_logger"
require "rails_event_logger/models/event_log"
require "rails_event_logger/controller/current_user_extension"
require "rails_event_logger/version"

module RailsEventLogger

  class << self
    attr_accessor :options, :defaults, :current_user_method
  end

  @current_user_method = :current_user

  module SetupMethods

    def has_event_logging(options = {})
      send :include, InstanceMethods
      send :extend,  ClassMethods

      ::RailsEventLogger.options = options
      ::RailsEventLogger.defaults = {
        event_type: "#{self.name}EventLog"
      }
    end

  end # module SetupMethods

  module ClassMethods
    def logs
      RailsEventLogger::Models::EventLog.where(event_type: ::RailsEventLogger.defaults[:event_type])
    end
  end # module ClassMethods

  module InstanceMethods
    def log_event(opts = {})
      opts = ::RailsEventLogger.defaults.merge(opts)
      opts[:item_id] = self.id unless opts[:item_id].present?
      opts[:user_id] = RailsEventLogger::User.current.try(:id) unless opts[:user_id].present?

      RailsEventLogger::Models::EventLog.create(
        event_type: opts[:event_type],
        item_id: opts[:item_id],
        logged_changes: opts[:logged_changes],
        user_id: opts[:user_id]
      )
    end

    def logs
      RailsEventLogger::Models::EventLog.where(item_id: self.id)
    end
  end # module InstanceMethods
end # module RailsEventLogger

ActiveRecord::Base.extend RailsEventLogger::SetupMethods
