require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe GameDetail do
  describe "moves_to_sgf" do
    before do
      @player1 = Player.create!(:name => 'player1')
      @player2 = Player.create!(:name => 'player2')
      @game = Game.create!(:moves => 0, :black_id => @player1.id, :white_id => @player2.id)
      GameDetail.create!(:game_id => @game.id, :whose_turn => Game::BLACK)
    end

    it "should return empty string if no move" do
      @game.detail.moves_to_sgf.should be_blank
    end

    it "should return moves with name on last node" do
      @game.stubs(:current_player).returns(@player1)
      @game.play :x => 1, :y => 2
      @game.detail.moves_to_sgf.should == ";B[ab]N[#{@game.detail.first_move.id}]"
    end
  end
end
