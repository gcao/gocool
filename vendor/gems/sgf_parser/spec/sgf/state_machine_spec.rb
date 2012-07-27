require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe StateMachine do
    before :each do
      @stm = StateMachine.new :start
    end
        
    it "state should return current state" do
      @stm.state.should == :start
    end
    
    it "transition should create transition" do
      callback = lambda{}
      @stm.transition :start, /a/, :end, callback
      
      t = @stm.transitions[:start][0]
      t.before_state.should == :start
      t.event_pattern.should == /a/
      t.after_state.should == :end
      t.callback.should == callback
    end
    
    it "transition should create multiple transitions for multiple start states" do
      @stm.transition [:start, :start2], /a/, :end
      
      t = @stm.transitions[:start][0]
      t.before_state.should == :start
      t.event_pattern.should == /a/
      t.after_state.should == :end
      t2 = @stm.transitions[:start2][0]
      t2.before_state.should == :start2
      t2.event_pattern.should == /a/
      t2.after_state.should == :end
    end
    
    it "transition_if should create transition with condition" do
      condition = lambda{}
      @stm.transition_if condition, :start, /a/, :end
      
      t = @stm.transitions[:start][0]
      t.condition.should == condition
      t.before_state.should == :start
      t.event_pattern.should == /a/
      t.after_state.should == :end
    end
    
    it "transition_if should create multiple transitions for multiple start states" do
      condition = lambda{}
      @stm.transition_if condition, [:start, :start2], /a/, :end
      
      t = @stm.transitions[:start][0]
      t.condition.should == condition
      t.before_state.should == :start
      t2 = @stm.transitions[:start2][0]
      t2.condition.should == condition
      t2.before_state.should == :start2
    end
    
    it "desc should set description for next transition" do
      @stm.desc 'conditional transition'
      @stm.transition [:start, :start2], /a/, :end
      
      @stm.transitions[:start][0].description.should == 'conditional transition'
      @stm.transitions[:start2][0].description.should == 'conditional transition'
    end
    
    it "desc should not description for transition after next transition" do
      @stm.desc 'conditional transition'
      @stm.transition [:start, :start2], /a/, :end
      @stm.transition :start3, /a/, :end
      
      @stm.transitions[:start3][0].description.should be_nil
    end
    
    it "reset should reset its state to start state" do
      @stm.transition :start, /.*/, :end
      @stm.event('a').should be_true
      @stm.state.should == :end
      
      @stm.reset
      
      @stm.state.should == :start
    end
    
    it "event should trigger state transition and return true if match the pattern" do
      @stm.transition :start, /.*/, :end
      @stm.event('a').should be_true
      @stm.state.should == :end
    end
    
    it "event should return false if no transition is defined for state" do
      @stm.event('a').should be_false
    end
    
    it "event should trigger state transition if current state is any of transition's start states and input match the pattern" do
      @stm.transition [:start, :another], /.*/, :end
      @stm.event 'a'
      @stm.state.should == :end
      @stm.instance_variable_set(:'@state', :another)
      @stm.event 'a'
      @stm.state.should == :end
    end
    
    it "event should not trigger state transition and return false if it does not match the pattern" do
      @stm.transition :start, /a/, :end
      @stm.event('b').should be_false
      @stm.state.should == :start
    end
    
    it "event should not trigger state transition and return false if condition is not met" do
      @stm.transition_if lambda{false}, :start, /a/, :end
      @stm.event('a').should be_false
      @stm.state.should == :start
    end
    
    it "nil means end of input" do
      @stm.transition :start, nil, :end
      @stm.end
      @stm.state.should == :end
    end
    
    it "transition should invoke the lambda if triggered by an event" do
      @stm.buffer = "123"
      @stm.transition :start, /4/, :end, lambda{|stm| @stm.buffer += @stm.input }
      @stm.event '4'
      @stm.buffer.should == "1234"
    end
    
    it "clear_buffer should clear buffer" do
      @stm.buffer = "abc"
      @stm.clear_buffer
      @stm.buffer.should == ""
    end
    
  end
end