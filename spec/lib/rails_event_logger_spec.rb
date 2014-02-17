require "spec_helper"

describe RailsEventLogger do
  it {should respond_to(:options)}
  it {should respond_to(:defaults)}
  it {should respond_to(:current_user_method)}
  
  context "class Methods" do
    
    describe "logs" do
      it "logs should return an empty array of logs" do
        expect(User.logs.empty?).to be_true
      end
    
      it "logs should return all logs for a class" do
        user1 = User.create(name: "Mustermann1")
        user2 = User.create(name: "Mustermann2")
      
        msg1 = {msg: "test log"}
        msg2 = {msg: "another test log"}
      
        user1.log_event(logged_changes: msg1)
        user2.log_event(logged_changes: msg2)
      
        expect(User.logs.count).to eq(2)
        expect(User.logs.first.logged_changes).to eq(msg1)
        expect(User.logs.where(item_id: user2.id).first.logged_changes).to eq(msg2)
      end 
    end # logs
    
    describe "has_event_logging" do
      it "should send class methods to another model" do
        User.should respond_to(:logs)
      end
      
      it "should send instance methods to another model" do
        User.new().should respond_to(:logs)
        User.new().should respond_to(:log_event)
      end
    end #has_event_logging
    
  end # class Merthods
  
  context "instance methods" do
    describe "log event" do
      
      it "should create an event_log" do
        user = User.create(name: "Mustermann")
        msg = {msg: "test message"}
        expect(RailsEventLogger::Models::EventLog).to receive(:create).with({event_type: "UserEventLog", user_id: nil, item_id: user.id, logged_changes: msg})
        user.log_event(logged_changes: msg)
      end
    
    end # log event
    
    describe "logs" do
      it "should return only logs for the instance called from" do
        user1 = User.create(name: "Mustermann1")
        user2 = User.create(name: "Mustermann2")
      
        msg1 = {msg: "user 1 log"}
        msg2 = {msg: "user 2 log"}
      
        user1.log_event(logged_changes: msg1)
        user2.log_event(logged_changes: msg2)
        
        expect(user1.logs.count).to eq(1)
        expect(user1.logs.first.logged_changes).to eq(msg1)
        expect(User.logs.count).to eq(2)
      end
    end #logs
    
  end #instance methods
end