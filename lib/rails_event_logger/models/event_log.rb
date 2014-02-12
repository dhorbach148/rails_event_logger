require 'protected_attributes'

module RailsEventLogger
  module Models
    class EventLog < ::ActiveRecord::Base
      attr_accessible :event_type, :item_id, :user_id, :logged_changes
      serialize :logged_changes
    end # class EventLog
  end # module Models
end # module RailsEventLogger
