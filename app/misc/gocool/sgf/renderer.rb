module Gocool
  module SGF
    class Renderer
      def render_property prop_name, value
        "#{prop_name}[#{value}]"
      end

      def render_position x, y
        ::SGF::Model::Constants::POSITIONS[x, 1] + ::SGF::Model::Constants::POSITIONS[y, 1]
      end
    end
  end
end
