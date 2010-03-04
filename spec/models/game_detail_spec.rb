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

    it "should return moves with name" do
      Game.any_instance.stubs(:logged_in?).returns(true)
      Game.any_instance.stubs(:current_player).returns(@player1)
      @game.play :x => 1, :y => 2
      @game.detail.moves_to_sgf.should == ";B[bc]N[#{@game.detail.first_move.id}]"
    end

    it "should return moves with name" do
      Game.any_instance.stubs(:logged_in?).returns(true)
      Game.any_instance.stubs(:current_player).returns(@player1)
      @game.play :x => 1, :y => 2
      Game.any_instance.stubs(:current_player).returns(@player2)
      @game.play :x => 3, :y => 4, :parent_move_id => @game.detail.last_move_id
      @game.detail.moves_to_sgf.should == ";B[bc]N[#{@game.detail.first_move.id}];W[de]N[#{@game.detail.last_move.id}]"
    end

    it "should return blank string if first move is a guess move" do
      Game.any_instance.stubs(:logged_in?).returns(true)
      Game.any_instance.stubs(:current_player).returns(@player2)
      @game.play :x => 1, :y => 2
      Game.any_instance.stubs(:current_player).returns(@player1)
      @game.detail.moves_to_sgf.should be_blank
    end

    it "should skip guess move" do
      Game.any_instance.stubs(:logged_in?).returns(true)
      Game.any_instance.stubs(:current_player).returns(@player1)
      @game.play :x => 1, :y => 2
      @game.play :x => 3, :y => 4, :parent_move_id => @game.detail.last_move_id
      Game.any_instance.stubs(:current_player).returns(@player2)
      @game.detail.moves_to_sgf.should == ";B[bc]N[#{@game.detail.first_move.id}]"
    end

    it "should return my guess move" do
      Game.any_instance.stubs(:logged_in?).returns(true)
      Game.any_instance.stubs(:current_player).returns(@player1)
      @game.play :x => 1, :y => 2
      @game.play :x => 3, :y => 4, :parent_move_id => @game.detail.last_move_id
      @game.detail.moves_to_sgf.should == ";B[bc]N[#{@game.detail.first_move.id}];W[de]N[#{GameMove.last.id}]"
    end
  end
end
