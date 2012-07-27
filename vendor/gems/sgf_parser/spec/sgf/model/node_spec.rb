require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe Node do
      describe "move_no" do
        it "should return parent node's move number + 1 if current node is a move" do
          parent = Node.new
          mock(parent).move_no{ 10 }
          node = Node.new(parent)
          node.sgf_play_black 'AB'
          node.move_no.should == 11
        end

        it "should return parent node's move number if current node is not a move" do
          parent = Node.new
          mock(parent).move_no{ 10 }
          node = Node.new(parent)
          node.move_no.should == 10
        end

        it "should return 0 if parent is nil and current node is not a move" do
          node = Node.new
          node.move_no.should == 0
        end
      
        it "should return 1 if parent is nil and current node is a move" do
          node = Node.new
          node.sgf_play_black "AB"
          node.move_no.should == 1
        end
      end
      
      it "sgf_setup_black should add an entry to black_moves" do
        node = Node.new
        node.sgf_setup_black "AB"
        node.black_moves.first.should == [0, 1]
      end
      
      it "sgf_setup_white should add an entry to white_moves" do
        node = Node.new
        node.sgf_setup_white "AB"
        node.white_moves.first.should == [0, 1]
      end
      
      it "sgf_play_black should set node type to MOVE and save move information" do
        node = Node.new
        node.sgf_play_black "AB"
        node.node_type.should == Constants::NODE_MOVE
        node.color.should == Constants::BLACK
        node.move.should == [0, 1]
      end
      
      it "sgf_play_black should set node type to PASS on empty move coordinate" do
        node = Node.new
        node.sgf_play_black "  "
        node.node_type.should == Constants::NODE_PASS
        node.color.should == Constants::BLACK
      end
      
      it "sgf_play_white should set node type to MOVE and save move information" do
        node = Node.new
        node.sgf_play_white "AB"
        node.node_type.should == Constants::NODE_MOVE
        node.color.should == Constants::WHITE
        node.move.should == [0, 1]
      end
      
      it "sgf_play_white should set node type to PASS on empty move coordinate" do
        node = Node.new
        node.sgf_play_white "  "
        node.node_type.should == Constants::NODE_PASS
        node.color.should == Constants::WHITE
      end

      it "child returns first child" do
        node = Node.new
        first_child = Node.new(node)
        second_child = Node.new(node)
        node.child.should == first_child
      end
    end
  end
end