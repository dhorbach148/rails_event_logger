require 'protected_attributes'

module RailsEventLogger
  module Models
    class EventLog < ::ActiveRecord::Base
      attr_accessible :event_type, :item_id, :user_id, :logged_changes
      serialize :logged_changes
      
      belongs_to :user, :class_name => '::User'
    end # class EventLog
  end # module Models
end # module RailsEventLogger
