module Gocool
  module SGF
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
        sgf << render_property("PW", game.white_player.name)
        sgf << render_property("WR", game.white_player.rank)
        sgf << render_property("PB", game.black_player.name)
        sgf << render_property("BR", game.black_player.rank)
        sgf << render_property("DT", game.created_at)
        sgf << render_property("PC", game.place)
        sgf << render_property("RU", game.rule_str)
        sgf << render_property("KM", game.komi)
        sgf << render_property("HA", game.handicap)
        sgf << render_property("RE", game.result)
        if game.detail
          sgf << render_moves(game)
        end
        sgf << ")"
      end

      private

      def render_moves game
        if game.current_user_is_player?
          sgf = game.detail.formatted_moves.to_s
          if game.detail.last_move.move_on_board?
            sgf << render_guess_moves(game.detail.guess_moves)
          else
            sgf << ";" << game.detail.last_move.to_sgf
          end
          sgf
        else
          game.detail.formatted_moves.to_s
        end
      end

      def render_guess_moves guess_moves
        guess_moves.map{|move|
          sgf = NodeRenderer.new(:with_name => true, :with_children => true, :player_id => game.current_player.id).render(move)
          sgf = "(#{sgf})" unless sgf.empty?
          sgf
        }.join
      end
    end
  end
end
