module SGF
  class StateMachineError < StandardError
  end
  
  class SGFStateMachine < StateMachine
    
    STATE_BEGIN           = :begin
    STATE_GAME_BEGIN      = :game_begin       
    STATE_GAME_END        = :game_end
    STATE_NODE            = :game_node             
    STATE_VAR_BEGIN       = :var_begin        
    STATE_VAR_END         = :var_end     
    STATE_PROP_NAME_BEGIN = :prop_name_begin
    STATE_PROP_NAME       = :prop_name        
    STATE_VALUE_BEGIN     = :value_begin      
    STATE_VALUE           = :value            
    STATE_VALUE_ESCAPE    = :value_escape
    STATE_VALUE_END       = :value_end
    STATE_INVALID         = :invalid
    
    def initialize
      super(STATE_BEGIN)

      start_game             = lambda{ |stm| return if stm.context.nil?; stm.context.start_game }
      end_game               = lambda{ |stm| return if stm.context.nil?; stm.context.end_game }
      start_node             = lambda{ |stm| return if stm.context.nil?; stm.context.start_node }
      start_variation        = lambda{ |stm| return if stm.context.nil?; stm.context.start_variation }
      store_input_in_buffer  = lambda{ |stm| return if stm.context.nil?; stm.buffer = stm.input }
      append_input_to_buffer = lambda{ |stm| return if stm.context.nil?; stm.buffer += stm.input }
      set_property_name      = lambda{ |stm| return if stm.context.nil?; stm.context.property_name = stm.buffer; stm.clear_buffer }
      set_property_value     = lambda{ |stm| return if stm.context.nil?; stm.context.property_value = stm.buffer; stm.clear_buffer }
      end_variation          = lambda{ |stm| return if stm.context.nil?; stm.context.end_variation }
      report_error           = lambda{ |stm| raise StateMachineError.new('SGF Error near "' + stm.input + '"') }

      transition STATE_BEGIN,        
                     /\(/,        
                     STATE_GAME_BEGIN,
                     start_game
                           
      transition [STATE_GAME_BEGIN, STATE_VAR_END, STATE_VALUE_END],   
                     /;/,
                     STATE_NODE,
                     start_node
      
      transition STATE_VAR_BEGIN,
                     /;/,
                     STATE_NODE
      
      transition [STATE_NODE, STATE_VAR_END, STATE_VALUE_END],
                     /\(/,        
                     STATE_VAR_BEGIN,
                     start_variation
      
      transition [STATE_NODE, STATE_VALUE_END],
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME_BEGIN,
                     store_input_in_buffer
      
      transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME],
                     /[a-zA-Z]/,
                     STATE_PROP_NAME,
                     append_input_to_buffer
      
      transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME],    
                     /\[/,        
                     STATE_VALUE_BEGIN,
                     set_property_name
        
      transition STATE_VALUE_END,
                     /\[/,        
                     STATE_VALUE_BEGIN
                     
      transition STATE_VALUE_BEGIN,
                     /[^\]]/,
                     STATE_VALUE,
                     store_input_in_buffer
                       
      transition [STATE_VALUE_BEGIN, STATE_VALUE],
                     /\\/,
                     STATE_VALUE_ESCAPE
                       
      transition STATE_VALUE_ESCAPE,
                     /./,
                     STATE_VALUE,
                     append_input_to_buffer
                       
      transition STATE_VALUE,
                     /[^\]]/,
                     nil,
                     append_input_to_buffer
                       
      transition [STATE_VALUE_BEGIN, STATE_VALUE],        
                     /\]/,        
                     STATE_VALUE_END,
                     set_property_value
                       
      transition STATE_VAR_END,        
                     nil,        
                     STATE_GAME_END,
                     end_game
    
      transition [STATE_NODE, STATE_VALUE_END, STATE_VAR_END],
                     /\)/,        
                     STATE_VAR_END,
                     end_variation

      transition [STATE_BEGIN, STATE_GAME_BEGIN, STATE_NODE, STATE_VAR_BEGIN, STATE_VAR_END, STATE_PROP_NAME_BEGIN, STATE_PROP_NAME, STATE_VALUE_END],
                     /[^\s]/, 
                     STATE_INVALID,
                     report_error
    end

#    # Overwrite parent to get better performance!
#    def event input
#      case @state
#        when STATE_NODE
#          if input > "A" and input < "Z" or input > "a" and input < "z"
#            @state = STATE_PROP_NAME_BEGIN
#            self.buffer = input
#            return
#          end
#        when STATE_VALUE_BEGIN
#          if input == "]"
#            self.state = STATE_VALUE_END
#            context.property_value = buffer if context
#            clear_buffer
#            return
#          elsif input != "\\"
#            self.state = STATE_VALUE
#            self.buffer = input
#            return
#          end
#        when STATE_VALUE
#          if input == "]"
#            self.state = STATE_VALUE_END
#            context.property_value = buffer if context
#            clear_buffer
#            return
#          elsif input != "\\"
#            self.buffer += input
#            return
#          end
#        when STATE_VALUE_END
#          if input == "\n"
#            return
#          elsif input == ";"
#            self.state = STATE_NODE
#            context.start_node if context
#            return
#          elsif input > "A" and input < "Z" or input > "a" and input < "z"
#            @state = STATE_PROP_NAME_BEGIN
#            self.buffer = input
#            return
#          end
#        when STATE_PROP_NAME_BEGIN, STATE_PROP_NAME
#          if input == "["
#            self.state = STATE_VALUE_BEGIN
#            context.property_name = buffer if context
#            clear_buffer
#          else
#            self.buffer += input
#          end
#          return
#        when STATE_VALUE_ESCAPE
#          self.state = STATE_VALUE
#          self.buffer += input
#          return
#      end
#
#      #puts input.inspect
#      super input
#    end
  end
end
