module Gocool
  module SGF
    class NodeRenderer < Renderer
      def initialize options = {}
        @options = {}.merge options
      end

      def render node
        return "" if node.guess_player_id and @options[:player_id] and node.guess_player_id != @options[:player_id]

        sgf = ""
        sgf << ";" if node.move_on_board?
        sgf << render_move(node.color, node.x, node.y)
        sgf << render_setup_points(node.setup_points)
        sgf << render_dead(node.dead)
        sgf << render_property("N", node.id) if @options[:with_name]
        sgf << render_property("C", I18n.t('games.guess_move_comment')) if node.move_no > 0 and node.color != 0 and node.player_id.nil?
        sgf << render_children(node.children) if @options[:with_children]
        sgf
      end

      private

      def render_children children
        return "" if children.blank?
        return render(children.first) if children.size == 1

        children.map {|move|
          sgf = render(move)
          sgf.empty? ? "" : "(#{sgf})"
        }.join
      end

      def render_dead dead
        return "" if dead.blank?

        "CR" + dead.map{|point| "[#{render_position(point[0], point[1])}]"}.join
      end

      def render_setup_points setup_points
        return "" if setup_points.blank?

        JSON.parse(setup_points).map {|item|
          op, x, y = *item
          if op == Game::ADD_BLACK_STONE
            render_property("AB", render_position(x, y))
          else
            ""
          end
        }.join
      end

      def render_move color, x, y
        return "" unless [::SGF::Model::Constants::BLACK, ::SGF::Model::Constants::WHITE].include?(color)

        prop_name = color == ::SGF::Model::Constants::WHITE ? "W" : "B"
        render_property(prop_name, render_position(x, y))
      end
    end
  end
end
