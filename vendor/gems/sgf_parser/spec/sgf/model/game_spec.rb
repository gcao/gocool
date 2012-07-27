require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe Game do
      it "moves should return number of moves" do
        game = Game.new
        n1 = Node.new game.root_node
        n1.sgf_play_black 'AB'
        n2 = Node.new n1
        n2.sgf_play_white 'BC'

        game.moves.should == 2
      end
      
      it "moves should not count non-move nodes" do
        game = Game.new
        n1 = Node.new game.root_node
        n1.sgf_play_black 'AB'
        dummy1 = Node.new(n1)
        n2 = Node.new dummy1
        n2.sgf_play_white 'BC'
        dummy2 = Node.new(n2)

        game.moves.should == 2
      end
    end
  end
end