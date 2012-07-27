module SGF
  class Parser    
    attr_reader :event_listener
    
    def initialize event_listener
      @event_listener = event_listener
      @stm = SGFStateMachine.new
      @stm.context = event_listener
    end
    
    def parse input
      @stm.reset
      
      raise ArgumentError.new if input.nil? or input.strip.empty?
      
      input.strip!
        
      0.upto(input.size - 1) do |i|
        @position = i
        @stm.event(input[i,1])
      end
      
      @stm.end
    rescue StateMachineError => e
      raise ParseError.new(input, @position, e.message)
    end
    
    def parse_file filename
      raise BinaryFileError if Parser.is_binary?(filename)
      File.open(filename) do |f|
        parse f.readlines.join
      end
    end
    
    class << self
      def parse input, debug = false
        parser = SGF::Parser.new(SGF::Model::EventListener.new(debug))
        parser.parse input
        parser.event_listener.game
      end
    
      def parse_file filename, debug = false
        parser = SGF::Parser.new(SGF::Model::EventListener.new(debug))
        parser.parse_file filename
        parser.event_listener.game
      end
      
      def is_binary? file
        # This does not work?!
        # parts = %x(/usr/bin/file -i #{file}).split(':', 2)
        # not parts[1].include?('text')
      end
    end

  end
end
