require "active_record"
require "rails_event_logger"
require "spec_helper"

describe RailsEventLogger::Models::EventLog do
  it {should respond_to(:user)}
  
  describe "mass assignment" do
    it "should create an event_log with item_id without errors" do
      event_log = RailsEventLogger::Models::EventLog.create(item_id: 123)
      expect(event_log.item_id).to eq(123)
    end
    it "should create an event_log with event_type without errors" do
      event_log = RailsEventLogger::Models::EventLog.create(event_type: "Testcase")
      expect(event_log.event_type).to eq("Testcase")
    end
    it "should create an event_log with user_id without errors" do
      event_log = RailsEventLogger::Models::EventLog.create(user_id: 123)
      expect(event_log.user_id).to eq(123)
    end
    it "should create an event_log with logged_changes without errors" do
      event_log = RailsEventLogger::Models::EventLog.create(logged_changes: {msg: "test clear"})
      expect(event_log.logged_changes).to eq({msg: "test clear"})
    end
  end
  
  describe "serialization" do
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