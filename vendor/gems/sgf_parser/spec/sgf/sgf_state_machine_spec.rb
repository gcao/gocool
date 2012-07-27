require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe SGFStateMachine do
    describe "with no context" do
      before :each do
        @stm = SGFStateMachine.new
      end

      it "should return state machine for sgf" do
        @stm.class.should == SGFStateMachine
      end

      it "should have start_state of #{SGFStateMachine::STATE_BEGIN}" do
        @stm.start_state.should == SGFStateMachine::STATE_BEGIN
      end
    
      [
        [SGFStateMachine::STATE_BEGIN,         '(', SGFStateMachine::STATE_GAME_BEGIN],
        [SGFStateMachine::STATE_GAME_BEGIN,    ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_NODE,          'A', SGFStateMachine::STATE_PROP_NAME_BEGIN],
        [SGFStateMachine::STATE_NODE,          ')', SGFStateMachine::STATE_VAR_END],
        [SGFStateMachine::STATE_PROP_NAME,     'A', SGFStateMachine::STATE_PROP_NAME],
        [SGFStateMachine::STATE_PROP_NAME,     '[', SGFStateMachine::STATE_VALUE_BEGIN],
        [SGFStateMachine::STATE_VALUE_BEGIN,   'A', SGFStateMachine::STATE_VALUE],
        [SGFStateMachine::STATE_VALUE_BEGIN,   ']', SGFStateMachine::STATE_VALUE_END],
        [SGFStateMachine::STATE_VALUE,         ']', SGFStateMachine::STATE_VALUE_END],
        [SGFStateMachine::STATE_VALUE,         '\\', SGFStateMachine::STATE_VALUE_ESCAPE],
        [SGFStateMachine::STATE_VALUE_ESCAPE,  ']', SGFStateMachine::STATE_VALUE],
        [SGFStateMachine::STATE_VALUE_END,     ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_VALUE_END,     '(', SGFStateMachine::STATE_VAR_BEGIN],
        [SGFStateMachine::STATE_VALUE_END,     ')', SGFStateMachine::STATE_VAR_END],
        [SGFStateMachine::STATE_VALUE_END,     'A', SGFStateMachine::STATE_PROP_NAME_BEGIN],
        [SGFStateMachine::STATE_VAR_BEGIN,     ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_VAR_END,       ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_VAR_END,       '(', SGFStateMachine::STATE_VAR_BEGIN]
      ].each do |state_before, input, state_after|
        it "should have transition for '#{state_before}' + '#{input}' => '#{state_after}'" do
          @stm.state = state_before
          @stm.event input
          @stm.state.should == state_after
        end
      end
      
      it "end should trigger transition to game_end" do
        @stm.state = SGFStateMachine::STATE_VAR_END
        @stm.end
        @stm.state.should == SGFStateMachine::STATE_GAME_END
      end
      
      it "should handle escaped characters" do
        @stm.state = SGFStateMachine::STATE_VALUE
        @stm.event '\\'
        @stm.state.should == SGFStateMachine::STATE_VALUE_ESCAPE
        @stm.event ']'
        @stm.state.should == SGFStateMachine::STATE_VALUE
      end
      
      [
        [SGFStateMachine::STATE_BEGIN           , 'A'],
        [SGFStateMachine::STATE_GAME_BEGIN      , '['],
        [SGFStateMachine::STATE_NODE            , '['],
        [SGFStateMachine::STATE_VAR_BEGIN       , '['],
        [SGFStateMachine::STATE_VAR_END         , '['],
        [SGFStateMachine::STATE_PROP_NAME_BEGIN , ']'],
        [SGFStateMachine::STATE_PROP_NAME       , ']'],
        [SGFStateMachine::STATE_VALUE_END       , ']'],
      ].each do |state_before, input|
        it "should raise error for '#{state_before}' + '#{input}'" do
          @stm.state = state_before
          lambda {
            @stm.event input
          }.should raise_error
        end
      end
    end
  
    describe "with context" do
      before :each do
        @context = Object.new
        @stm = SGFStateMachine.new
        @stm.context = @context
        @stm.reset
      end
      
      it "Transition to game begin should call context.start_game" do
        mock(@context).start_game
        @stm.state = SGFStateMachine::STATE_BEGIN
        @stm.event "("
      end
      
      it "Transition to node should call context.start_node" do
        mock(@context).start_node
        @stm.state = SGFStateMachine::STATE_GAME_BEGIN
        @stm.event ";"
      end
      
      it "Transition to variation begin should call context.start_variation" do
        mock(@context).start_variation
        @stm.state = SGFStateMachine::STATE_NODE
        @stm.event "("
      end
      
      it "Transition to prop name begin should set store input to buffer" do
        @stm.state = SGFStateMachine::STATE_NODE
        @stm.event "A"
        @stm.buffer.should == "A"
      end

      it "Transition to prop name from prop name begin should append input to buffer" do
        @stm.buffer = "A"
        @stm.state = SGFStateMachine::STATE_PROP_NAME_BEGIN
        @stm.event "B"
        @stm.buffer.should == "AB"
      end
      
      it "Transition to game variation end should call context.end_variation" do
        mock(@context).end_variation
        @stm.state = SGFStateMachine::STATE_VALUE_END
        @stm.event ")"
      end
      
      it "Transition to value begin should call context.property_name= with buffer" do
        mock(@context).property_name = "AB"
        @stm.buffer = "AB"
        @stm.state = SGFStateMachine::STATE_PROP_NAME
        @stm.event "["
      end
      
      it "Transition to value should store input to buffer" do
        @stm.buffer = "AB"
        @stm.state = SGFStateMachine::STATE_VALUE_BEGIN
        @stm.event "V"
        @stm.buffer.should == "V"
      end

      it "Transition from value escape to value should store input to buffer" do
        @stm.buffer = "AB"
        @stm.state = SGFStateMachine::STATE_VALUE_ESCAPE
        @stm.event "V"
        @stm.buffer.should == "ABV"
      end
      
      it "Transition to value from value should append input to buffer" do
        @stm.buffer = "Valu"
        @stm.state = SGFStateMachine::STATE_VALUE
        @stm.event "e"
        @stm.buffer.should == "Value"
      end
      
      it "Transition to value end should call context.property_value" do
        mock(@context).property_value = "Value"
        @stm.buffer = "Value"
        @stm.state = SGFStateMachine::STATE_VALUE
        @stm.event "]"
      end
      
      it "Transition to node from variation begin should not create node" do
        dont_allow(@context).start_node
        @stm.state = SGFStateMachine::STATE_VAR_BEGIN
        @stm.event ";"
      end
    end
    
  end
end
