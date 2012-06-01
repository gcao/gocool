module CoolGames
  module Sgf
    class GameRenderer < Renderer
      def initialize options = {}
        @options = {}.merge options
      end

      def render game
        sgf = "(;"
        sgf << render_property("GM", "1")
        sgf << render_property("FF", "4")
        sgf << render_property("CA", "UTF-8")
        sgf << render_property("SZ", game.board_size || 19)
        sgf << render_property("PW", game.white_player.nil_or.name)
        sgf << render_property("WR", game.white_player.nil_or.rank)
        sgf << render_property("PB", game.black_player.nil_or.name)
        sgf << render_property("BR", game.black_player.nil_or.rank)
        sgf << render_property("DT", game.created_at)
        sgf << render_property("PC", game.place)
        sgf << render_property("RU", game.rule_str)
        sgf << render_property("KM", game.komi)
        sgf << render_property("HA", game.handicap)
        sgf << render_property("RE", game.result)
        if game.detail
          sgf << render_moves(game)
          if %w(counting_preparation counting black_accept_counting white_accept_counting).include? game.state
            sgf << ";" << NodeRenderer.new.render(game.detail.last_move)
            sgf << render_territories(game)
          end
        end
        sgf << ")"
      end

      private

      def render_moves game
        sgf = game.detail.formatted_moves.to_s
        sgf << render_guess_moves(game) if game.current_user_is_player?
        sgf
      end

      def render_guess_moves game
        guess_moves = game.detail.guess_moves
        guess_moves.map{|move|
          sgf = NodeRenderer.new(:with_name => true, :with_children => true, :player_id => game.current_user.player.id).render(move)
          sgf = "(#{sgf})" unless sgf.empty?
          sgf
        }.join
      end

      def render_territories game
        sgf = ";LB"
        board = game.detail.last_move.board
        for i in 0..game.board_size - 1
          for j in 0..game.board_size - 1
            sgf << "[" << render_position(i, j) << ":"
            case board[i][j]
              when Board::BLACK, Board::BLACK_TERRITORY, Board::WHITE_DEAD
                sgf << "B"
              when Board::WHITE, Board::WHITE_TERRITORY, Board::BLACK_DEAD
                sgf << "W"
              when Board::SHARED
                sgf << "S"
            end
            sgf << "]"
          end
        end
        sgf
      end
    end
  end
end
