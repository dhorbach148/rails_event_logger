require "spec_helper"

describe RailsEventLogger do
  it {should respond_to(:options)}
  it {should respond_to(:defaults)}
  it {should respond_to(:current_user_method)}
  
  describe "class Methods" do
    describe "logs" do
      
      context "no logs present" do
        it "should return an empty array of logs" do
          expect(User.logs.empty?).to be_true
        end
      end# context
      
      context "logs present" do
        before do
          @user1 = User.create(name: "Mustermann1")
          @user2 = User.create(name: "Mustermann2")
      
          @msg1 = {msg: "test log"}
          @msg2 = {msg: "another test log"}
      
          @user1.log_event(logged_changes: @msg1)
          @user2.log_event(logged_changes: @msg2)
        end
    
        it "should return an array" do
          expect(User.logs.class).to eq(ActiveRecord::Relation::ActiveRecord_Relation_RailsEventLogger_Models_EventLog)
        end
        
        it "should return all logs for a class" do    
          expect(User.logs.count).to eq(2)
        end
        
        it "first entry should have the right logged_changes" do
          expect(User.logs.first.logged_changes).to eq(@msg1)
        end
        
        it "second entry should have the right logged_changes" do
          expect(User.logs.where(item_id: @user2.id).first.logged_changes).to eq(@msg2)
        end
      end#context     
    end # logs
    
    describe "has_event_logging" do
      it "should send class methods to another model" do
        expect(User).to respond_to(:logs)
      end
      
      context "should send instance methods to another model" do
        it "should respond to logs" do
          expect(User.new()).to respond_to(:logs)
        end
        
        it "should respond to log_event" do
          expect(User.new()).to respond_to(:log_event)
        end
      end#context
    end #has_event_logging
    
  end # class Merthods
  
  describe "instance methods" do
    describe "log event" do
      
      it "should create an event_log" do
        user = User.create(name: "Mustermann")
        msg = {msg: "test message"}
        expect(RailsEventLogger::Models::EventLog).to receive(:create).with({event_type: "UserEventLog", user_id: nil, item_id: user.id, logged_changes: msg})
        user.log_event(logged_changes: msg)
      end
    
    end # log event
    
    describe "logs" do
      context "should return only logs for the instance called from" do
        before do
          @user1 = User.create(name: "Mustermann1")
          @user2 = User.create(name: "Mustermann2")
          
          @msg1 = {msg: "user 1 log"}
          @msg2 = {msg: "user 2 log"}
          
          @user1.log_event(logged_changes: @msg1)
          @user2.log_event(logged_changes: @msg2)
        end
        
        it "should have one log" do
          expect(@user1.logs.count).to eq(1)
        end
        
        it "should have the right logged_changes" do
          expect(@user1.logs.first.logged_changes).to eq(@msg1)
        end
        
        it "should exist more then one event_log" do
          expect(User.logs.count).to eq(2)
        end
      end
    end #logs
    
  end #instance methods
end