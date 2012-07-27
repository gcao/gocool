module SGF
  module Model
    class Node
      include Constants
      include SGF::SGFHelper
      
      attr_reader :node_type, :color, :move, :black_moves, :white_moves, :labels
      attr_reader :parent, :children
      attr_accessor :comment, :whose_turn
      
      def initialize parent = nil
        @parent     = parent
        @node_type  = NODE_SETUP
        @labels     = []
        @whose_turn = BLACK
        @trunk      = true
        if parent
          @trunk = parent.trunk?
          @parent.children << self
        end
      end
      
      def move_no
        parent_move_no = parent.nil? ? 0 : parent.move_no
        self.node_type == NODE_MOVE ? parent_move_no + 1 : parent_move_no
      end
      
      def misc_properties
        @misc_properties ||= {}
      end
      
      def whose_turn= input
        @whose_turn = input.to_i
      end
      
      def black_moves
        @black_moves ||= []
      end
      
      def white_moves
        @white_moves ||= []
      end
      
      def clear_moves
        @white_moves ||= []
      end
      
      def children
        @children ||= []
      end
      
      def child
        @children.first
      end
      
      def root?
        @parent.nil?
      end
      
      def trunk?
        @trunk
      end
      
      def last?
        @children.nil? or @children.empty?
      end
      
      def variation_root= value
        @variation_root = value
        @trunk = false if value
      end
      
      def variation_root?
        @variation_root
      end
      
      def sgf_setup_black input
        to_position_array(input).each {|position| self.black_moves << position}
      end
      
      def sgf_setup_white input
        to_position_array(input).each {|position| self.white_moves << position}
      end
      
      def sgf_setup_clear input
        to_position_array(input).each {|position| self.clear_moves << position}
      end
      
      def sgf_play_black input
        @color = BLACK
        set_move input
      end
      
      def sgf_play_white input
        @color = WHITE
        set_move input
      end
      
      def sgf_label input
        @labels << to_label(input)
      end
      
      private
      
      def set_move input
        if input.nil? or input.strip.size == 0
          @node_type = NODE_PASS
        else
          @node_type = NODE_MOVE
          @move      = to_position(input)
        end
      end
    end
  end
end