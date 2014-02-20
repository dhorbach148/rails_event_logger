require "active_record"
require "rails_event_logger"
require "spec_helper"

describe RailsEventLogger::Models::EventLog do
  it {should respond_to(:item_id)}
  it {should respond_to(:event_type)}
  it {should respond_to(:user_id)}
  it {should respond_to(:logged_changes)}
  it {should respond_to(:user)}
  
  context "serialization" do
    before do
      @log = RailsEventLogger::Models::EventLog.new(item_id: 1, event_type: "TestEvent", user_id: 1, logged_changes: {a: 1, b: 2, b: 3})
      @log.save
    end
    
    it "should deserialize the data" do
      @log.reload
      expect(@log.logged_changes).to eq({a: 1, b: 2, b: 3})
    end
    
  end
end