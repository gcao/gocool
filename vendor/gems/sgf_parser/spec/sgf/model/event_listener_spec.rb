require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe EventListener do
      before :each do
        @listener = EventListener.new
      end
      
      (DefaultEventListener.instance_methods - DefaultEventListener.superclass.instance_methods).each do |method|
        it "should implement #{method} from SGF::DefaultEventListener" do
          @listener.methods.should include(method)
        end
      end
      
      it "should start a new game on start_game" do
        @listener.start_game
        game1 = @listener.game
        @listener.start_game
        game2 = @listener.game
        game1.should_not == game2
      end
      
      it "start_variation should create a new node as variation root" do
        @listener.start_game
        @listener.start_node
        node = @listener.node
        @listener.start_variation
        @listener.node.should_not == node
        @listener.node.variation_root?.should be_true
      end
      
      it "end_variation should set current node as parent of current variation's root" do
        @listener.start_game
        @listener.start_node
        node = @listener.node
        @listener.start_variation
        @listener.node.should_not == node
        @listener.end_variation
        @listener.node.should == node
      end
      
      SGF::Model::GAME_PROPERTY_MAPPINGS.each do |prop_name, attr_name|
        it "call property_name=#{prop_name} and property_value=something should set #{attr_name} on game" do
          mock(@listener.game).send(attr_name, '123')
          @listener.property_name = prop_name
          @listener.property_value = '123'
        end
      end

      it "should set node as game's root node on first call to start_node" do
        @listener.start_game
        @listener.start_node
        @listener.node.should == @listener.game.root_node
      end
      
      it "should create child node on current node when call start_node" do
        @listener.start_game
        @listener.start_node
        node = @listener.node
        @listener.start_node
        @listener.node.should_not == node
        @listener.node.parent.should == node
        node.children.should == [@listener.node]
      end
      
      it "property_name='C' and property_value=something should add comment to node" do
        @listener.start_game
        @listener.start_node
        @listener.property_name = "C"
        @listener.property_value = "comment"
        @listener.game.root_node.comment.should == 'comment'
      end
      
      it "game misc properties" do
        @listener.start_game
        @listener.start_node
        @listener.property_name = "US"
        @listener.property_value = "A"
        @listener.game.misc_properties["US"].should == "A"
        @listener.property_value = "B"
        @listener.game.misc_properties["US"].should == ["A", "B"]
      end

      it "node misc properties" do
        @listener.start_game
        @listener.start_node
        @listener.property_name = "TR"
        @listener.property_value = "AB"
        @listener.node.misc_properties["TR"].should == "AB"
        @listener.property_value = "AC"
        @listener.node.misc_properties["TR"].should == ["AB", "AC"]
      end
      
    end
  end
end
