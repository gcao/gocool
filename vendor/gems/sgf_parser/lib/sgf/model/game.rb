module SGF
  module Model
    class Game
      include Constants
      include SGF::SGFHelper
      
      attr_accessor :game_type, :name, :rule, :board_size, :handicap, :komi, 
                    :black_player, :black_rank, :white_player, :white_rank,
                    :black_team, :white_team,
                    :time_rule, :overtime_rule, :result, 
                    :played_on, :program, :place, :event, :round, :source,
                    :annotation, :comment

      def initialize
        @game_type   = WEIQI
        @board_size  = DEFAULT_BOARD_SIZE
        @handicap    = 0
        @komi        = DEFAULT_KOMI
      end
      
      def misc_properties
        @misc_properties ||= {}
      end
      
      def game_type=(value);  @game_type  = value.to_i; end
      def board_size=(value); @board_size = value.to_i; end
      def handicap=(value);   @handicap   = value.to_i; end
      def komi=(value);       @komi       = value.to_f; end

      def root_node
        @root_node ||= Node.new(nil)
      end
      
      def time_rule
        @time_rule.to_s + (overtime_rule ? " (#{overtime_rule})" : "")
      end
      
      def moves
        moves = 0
        
        node = root_node
        while node
          moves = node.move_no
          node = node.children[0]
        end
        
        moves
      end
      
    end
  end
end
