require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

module Gocool::SGF
  describe GameRenderer do
    before do
      @g = Game.create!(:board_size => 19, :black_name => 'Black', :black_rank => "2d",
                        :white_name => 'White', :white_rank => "3d", :place => 'TEST', :rule => Game::CHINESE_RULE,
                        :komi => 7.5)
    end

    it "should generate sgf for new game" do
      GameRenderer.new.render(game).should == "(;GM[1]FF[4]CA[UTF-8]SZ[19]PW[White]WR[3d]PB[Black]BR[2d]DT[#{@g.created_at}]PC[TEST]RU[#{@g.rule_str}]KM[7.5]HA[]RE[]N[#{@g.detail.first_move_id}];)"
    end
  end
end
