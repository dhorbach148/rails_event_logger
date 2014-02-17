class User < ActiveRecord::Base
  attr_accessible :user
  
  has_event_logging
end
