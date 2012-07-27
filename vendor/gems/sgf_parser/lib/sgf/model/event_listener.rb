module SGF
  module Model
    class EventListener < SGF::DefaultEventListener
      include SGF::SGFHelper
      
      attr_reader :game, :node
      
      def initialize debug_mode = false
        super(debug_mode)
      end
      
      def start_game
        super
        
        @game = Game.new
      end
      
      def start_variation
        super
        
        @node = Node.new(@node)
        @node.variation_root = true
      end
      
      def end_variation
        super
        
        @node = find_variation_root(@node).parent
      end
      
      def start_node
        super
        
        @node = @node.nil? ? game.root_node : Node.new(@node)
      end
      
      def property_name= name
        super name
        
        @property_name = name
      end
      
      def property_value= value
        super value
        
        set_property @property_name, value
      end
      
      private
      
      def find_variation_root node
        while not node.variation_root?
          return node if node.parent.nil?
          
          node = node.parent
        end
        node
      end
      
      def set_property name, value
        return unless name
        name = name.strip.upcase
        value.strip! unless value.nil?
        
        return if GAME_PROPERTY_HANDLER.handle(game, name, value)
        return if NODE_PROPERTY_HANDLER.handle(node, name, value)

        puts "WARNING: SGF property is not recognized(name=#{name}, value=#{value})"
      end
    end
  end
end