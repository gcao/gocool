module Gocool
  module SGF
    class Renderer
      def render_property prop_name, value
        "#{prop_name}[#{value}]"
      end
    end
  end
end
