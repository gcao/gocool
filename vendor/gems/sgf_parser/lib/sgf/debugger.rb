module SGF
  module Debugger
    def enable_debug_mode
      @debug_mode = true
    end
    
    def disable_debug_mode
      @debug_mode = false
    end
    
    def debug message
      puts message if @debug_mode
    end
  end
end