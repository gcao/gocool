module SGF
  class ParseError < StandardError
    attr_reader :input, :position, :description
    
    def initialize input, position, description = nil
      @input = input
      @position = position
      @description = description || "SGF parse error occurred here "
    end
    
    def to_s
      if @position > 1000
        start_position = @position - 1000
        s = '...'
      else
        start_position = 0
        s = ''
      end
      s << @input[start_position..@position]
      s << ' <=== '
      s << description.to_s
    end

  end
end