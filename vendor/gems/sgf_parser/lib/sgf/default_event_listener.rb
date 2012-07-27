module SGF
  class DefaultEventListener
    include Debugger
    
    def initialize debug_mode = false
      enable_debug_mode if debug_mode
    end
    
    def start_game
      debug 'start_game'
    end
    
    def start_node
      debug 'start_node'
    end
    
    def property_name= name
      debug "property_name = '#{name}'"
    end
    
    def property_value= value
      debug "property_value = '#{value}'"
    end
    
    def start_variation
      debug "start_variation"
    end
    
    def end_variation
      debug "end_variation"
    end
    
    def end_game
      debug "end_game"
    end   
  end
end