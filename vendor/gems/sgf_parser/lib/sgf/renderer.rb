module SGF
  # Renderer is called by a client program to render client object in SGF format.
  class Renderer
      
    def render_node node
      raise 'INCOMPLETE'
      result = ""
      
      if type == NODE_SETUP
        unless black_moves.empty?
        end
        
        unless white_moves.empty?
        end
        
      else
        result << (color == BLACK ? "B" : "W")
        result << "[" << "" << "]"
      end
      
      result << "C[" << comment << "]" unless comment.nil?
      result
    end
  end
end