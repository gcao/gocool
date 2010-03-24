require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

module Gocool::SGF
  describe GameRenderer do
    before do
      @black_player = Player.create!(:name => 'Black', :rank => '3d')
      @white_player = Player.create!(:name => 'White', :rank => '4d')

      @g = Game.create!(:board_size => 19, :black_id => @black_player.id, :white_id => @white_player.id,
                        :start_side => Game::BLACK, :moves => 0,
                        :place => 'TEST', :rule => Game::CHINESE_RULE, :komi => 7.5)

      GameDetail.create!(:game_id => @g.id, :whose_turn => @g.start_side, :formatted_moves => "")

      @sgf = "(;GM[1]FF[4]CA[UTF-8]SZ[19]PW[White]WR[4d]PB[Black]BR[3d]DT[#{@g.created_at}]PC[TEST]RU[#{@g.rule_str}]KM[7.5]HA[]RE[]N[#{@g.detail.first_move_id}]"
    end

    it "should generate sgf for new game" do
      GameRenderer.new.render(@g).should == "#{@sgf})"
    end

    it "should generate sgf with moves" do
      @g.stubs(:logged_in?).returns(true)
      @g.stubs(:current_player).returns(@black_player)
      @g.play(:parent_move_id => @g.detail.first_move_id, :x => 3, :y => 4)
      GameRenderer.new.render(@g).should == "#{@sgf};B[de]N[#{@g.detail.last_move_id}])"
    end
  end
end
