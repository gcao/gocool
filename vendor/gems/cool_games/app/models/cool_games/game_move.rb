module CoolGames
  class GameMove
    include Mongoid::Document
    include Mongoid::Timestamps

    OCCUPIED = 1
    SUICIDE  = 2
    BAD_KO   = 3

    embedded_in :game        , class_name: 'CoolGames::Game'
    embedded_in :parent      , class_name: "CoolGames::GameMove", :cyclic => true
    embeds_many :children    , class_name: "CoolGames::GameMove", :cyclic => true
    belongs_to  :player      , class_name: 'CoolGames::Player'
    belongs_to  :guess_player, class_name: 'CoolGames::Player'

    field "move_no"         , type: Integer
    field "color"           , type: Integer
    field "x"               , type: Integer
    field "y"               , type: Integer
    field "dead"            , type: String
    field "played_at"       , type: Date
    field "setup_points"    , type: String
    field "serialized_board", type: String

    #scope :moves_after, lambda { |move|
    #  {:conditions => ["game_detail_id = ? and id > ?", move.game_detail_id, move.id]}
    #}

    def move_on_board?
      color != Game::NONE
    end

    #def children moves = nil
    #  return @children unless @children.nil?

    #  @children = []
    #  moves ||= self.class.moves_after(self)
    #  moves.each do |move|
    #    if move.parent_id == id
    #      @children << move
    #      moves.delete_at moves.index(move)
    #    end
    #  end

    #  @children.each do |move|
    #    move.children moves
    #  end

    #  @children
    #end

    def board
      return @board if @board
      return @board = Board.load(serialized_board) if serialized_board

      init_board
    end

    def process
      return OCCUPIED if parent and parent.board.occupied?(x, y)

      init_board

      return SUICIDE if suicide?
      return BAD_KO if check_ko

      self.serialized_board = board.dump
    end

    def child_that_matches x, y
      children.detect {|move| move.x == x and move.y == y }
    end

    private

    def init_board
      if parent
        @board = parent.board.clone
      else
        @board = Board.new(game.board_size, game.game_type)
      end

      self.dead = @board.play(color, x, y)

      @board
    end

    def check_ko
      return if dead.blank? or dead.size != 1
      return unless parent
      return if parent.dead.blank? or parent.dead.size != 1

      dead_x, dead_y = *dead[0]
      old_dead_x, old_dead_y = *parent.dead[0]

      dead_x == parent.x and dead_y == parent.y and old_dead_x == x and old_dead_y == y
    end

    def suicide?
      dead.include?([x, y])
    end
  end
end
