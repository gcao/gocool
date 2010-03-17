require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe GameMove do
  before do
    @g = Game.create!(:board_size => 19)
    GameDetail.create!(:game_id => @g.id)
    @g.reload
  end

  context "board" do
    it "should return current board status" do
      board = @g.detail.last_move.board
      board.class.should == Board
      board.size.should == @g.board_size
    end

    it "should add current move to board" do
      move = GameMove.create!(:game_detail_id => @g.detail.id, :move_no => 1, :color => Game::BLACK, :x => 3, :y => 2, :parent_id => @g.detail.last_move_id)
      move.board[3][2].should == Game::BLACK
    end

    it "should should remove dead stones from board" do
      move1 = GameMove.create!(:game_detail_id => @g.detail.id, :move_no => 1, :color => Game::BLACK, :x => 1, :y => 0, :parent_id => @g.detail.last_move_id)
      move2 = GameMove.create!(:game_detail_id => @g.detail.id, :move_no => 2, :color => Game::WHITE, :x => 0, :y => 0, :parent_id => move1.id)
      move2.board[0][0].should == Game::WHITE
      move3 = GameMove.create!(:game_detail_id => @g.detail.id, :move_no => 3, :color => Game::BLACK, :x => 0, :y => 1, :parent_id => move2.id)
      move3.board[0][0].should == Game::NONE
    end
  end
end
