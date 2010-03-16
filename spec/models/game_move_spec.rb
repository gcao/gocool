require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe GameMove do
  before do
    @g = Game.create!(:board_size => 19)
    GameDetail.create!(:game_id => @g.id)
    @g.reload
  end

  context "board" do
    it "should return current board status" do
      board = @g.detail.first_move.board
      board.class.should == Board
      board.size.should == @g.board_size
    end
  end
end
