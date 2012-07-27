module SGF
  class StateMachine
    include SGF::Debugger
    
    Transition = Struct.new(:description, :condition, :before_state, :event_pattern, :after_state, :callback)

    attr_reader :start_state, :transitions
    attr_reader :before_state, :input
    attr_accessor :state, :context, :buffer
    
    def initialize start_state
      @start_state = @state = start_state
      @transitions = {}
      @buffer = ""
    end
    
    def desc description
      @description = description
    end
    
    def transition before_state, event_pattern, after_state, callback = nil
      transition_if nil, before_state, event_pattern, after_state, callback
    end
    
    def transition_if condition, before_state, event_pattern, after_state, callback = nil
      if before_state.class == Array
        saved_description = @description
        before_state.each do |s|
          @description = saved_description
          transition_if(condition, s, event_pattern, after_state, callback)
        end
        return
      end
      
      transition = self.transitions[before_state] ||= []
      transition << Transition.new(@description, condition, before_state, event_pattern, after_state, callback)
      
      @description = nil
    end
    
    def reset
      @state = @start_state
    end
    
    def event input
      debug "'#{@state}' + '#{input}'"
      @before_state = @state
      @input = input
      
      transitions_for_state = self.transitions[@state]
      return false unless transitions_for_state
      
      transition = transitions_for_state.detect do |t|
        next false if t.condition and not t.condition.call(self)
        
        (input.nil? and t.event_pattern.nil?) or input =~ t.event_pattern
      end
      
      if transition
        @state = transition.after_state unless transition.after_state.nil?
        transition.callback.call(self) unless transition.callback.nil?
        true
      else
        false
      end
    end
    
    def end
      event nil
    end
    
    def clear_buffer
      self.buffer = ""
    end
  end
end
