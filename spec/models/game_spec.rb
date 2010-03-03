require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Game do
  
  it "load_parsed_game should copy game information from a sgf game" do
    parsed_game = SGF::Model::Game.new
    parsed_game.name = 'Name'
    parsed_game.black_player = 'Black'
    parsed_game.white_player = 'White'
    parsed_game.played_on = '1999-01-02'
    parsed_game.rule = 'Chinese'
    parsed_game.board_size = 13
    parsed_game.handicap = 4
    parsed_game.komi = 7.5
    parsed_game.time_rule = '30:00(5x1:00)'
    parsed_game.program = 'IGS Client'
    parsed_game.result = 'W+R'
    game = Game.new
    game.load_parsed_game(parsed_game)
    game.name.should == parsed_game.name
    game.black_name.should == parsed_game.black_player
    game.white_name.should == parsed_game.white_player
    game.played_at_raw.should == parsed_game.played_on
    game.rule_raw.should == parsed_game.rule
    game.board_size.should == parsed_game.board_size
    game.handicap.should == parsed_game.handicap
    game.rule_raw.should == parsed_game.rule
    game.time_rule.should == parsed_game.time_rule
    game.program.should == parsed_game.program
    game.result.should == parsed_game.result
  end
  
  it "search should return games found" do
    pending
    game1 = Game.create!(:black_name => 'first_player', :white_name => 'second_player', :name => 'first vs second')
    game2 = Game.create!(:black_name => 'second_player', :white_name => 'first_player', :name => 'second vs first')
    
    Game.search(nil, 'first', nil).should == [game1, game2]
  end

  describe "play" do
    before do
      @player1 = Player.create!(:name => 'player1')
      @player2 = Player.create!(:name => 'player2')
      @game = Game.create!(:moves => 0, :black_id => @player1.id, :white_id => @player2.id)
      GameDetail.create!(:game_id => @game.id, :whose_turn => Game::BLACK)
    end

    it "first move" do
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})

      @game.moves.should == 1
      @game.detail.whose_turn.should == Game::WHITE
      move = @game.detail.first_move
      move.move_no.should == 1
      move.color.should == Game::BLACK
      move.x.should == 1
      move.y.should == 2
      move.player_id.should == @player1.id
      move.guess_player_id.should be_blank
      @game.detail.last_move.should == move
    end

    it "first guess move" do
      @game.stubs(:current_player).returns(@player2)
      @game.play({:x => 1, :y => 2})

      @game.moves.should == 0
      @game.detail.whose_turn.should == Game::BLACK
      @game.detail.first_move_id.should be_blank
      @game.detail.last_move_id.should be_blank
      move = GameMove.find_by_game_detail_id(@game.detail.id)
      move.move_no.should == 1
      move.color.should == Game::BLACK
      move.x.should == 1
      move.y.should == 2
      move.player_id.should be_blank
      move.guess_player_id.should == @player2.id
    end

    it "second move" do
      # first move
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})
      first_move = @game.detail.last_move
      first_move.should_not be_blank
      # second move
      @game.stubs(:current_player).returns(@player2)
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})

      @game.moves.should == 2
      @game.detail.whose_turn.should == Game::BLACK
      move = @game.detail.last_move.reload
      move.move_no.should == 2
      move.color.should == Game::WHITE
      move.x.should == 3
      move.y.should == 4
      move.player_id.should == @player2.id
      move.guess_player_id.should be_blank
      move.parent_id.should == @game.detail.first_move_id
      @game.detail.first_move_id.should_not == move.id
    end

    it "second move is a guess move" do
      # first move
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})
      first_move = @game.detail.last_move
      first_move.should_not be_blank
      # second guess move
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})

      @game.moves.should == 1
      @game.detail.whose_turn.should == Game::WHITE
      @game.detail.reload
      @game.detail.last_move_id.should == first_move.id
      move = GameMove.last
      move.game_detail_id.should == @game.detail.id
      move.move_no.should == 2
      move.color.should == Game::WHITE
      move.x.should == 3
      move.y.should == 4
      move.player_id.should be_blank
      move.guess_player_id.should == @player1.id
      move.parent_id.should == @game.detail.first_move_id
    end

    it "second move that matches a guess move" do
      # first move
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})
      first_move = @game.detail.last_move
      first_move.should_not be_blank
      # second guess move
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})
      # second move
      @game.stubs(:current_player).returns(@player2)
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})

      @game.moves.should == 2
      @game.detail.whose_turn.should == Game::BLACK
      move = @game.detail.last_move.reload
      move.move_no.should == 2
      move.color.should == Game::WHITE
      move.x.should == 3
      move.y.should == 4
      move.player_id.should == @player2.id
      move.guess_player_id.should == @player1.id
      move.parent_id.should == @game.detail.first_move_id
    end

    it "second move that does not match a guess move" do
      # first move
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})
      first_move = @game.detail.last_move
      first_move.should_not be_blank
      # second guess move
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})
      # second move
      @game.stubs(:current_player).returns(@player2)
      @game.play({:x => 5, :y => 6, :parent_move_id => first_move.id})

      @game.moves.should == 2
      @game.detail.whose_turn.should == Game::BLACK
      move = @game.detail.last_move.reload
      move.move_no.should == 2
      move.color.should == Game::WHITE
      move.x.should == 5
      move.y.should == 6
      move.player_id.should == @player2.id
      move.guess_player_id.should be_blank
      move.parent_id.should == @game.detail.first_move_id
    end

    it "second and third moves are guess moves" do
      # first move
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})
      first_move = @game.detail.last_move
      first_move.should_not be_blank
      # second: guess move
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})
      second_move = first_move.children.first
      # third: guess move
      @game.play({:x => 5, :y => 6, :parent_move_id => second_move.id})

      @game.moves.should == 1
      @game.detail.whose_turn.should == Game::WHITE
      @game.detail.reload
      @game.detail.last_move_id.should == first_move.id
      move = GameMove.last
      move.game_detail_id.should == @game.detail.id
      move.move_no.should == 3
      move.color.should == Game::BLACK
      move.x.should == 5
      move.y.should == 6
      move.player_id.should be_blank
      move.guess_player_id.should be_blank
      move.parent_id.should == second_move.id
    end

    it "should not accept 2nd move against a guess move" do
      # first move
      @game.stubs(:current_player).returns(@player1)
      @game.play({:x => 1, :y => 2})
      first_move = @game.detail.last_move
      first_move.should_not be_blank
      # second: guess move
      @game.play({:x => 3, :y => 4, :parent_move_id => first_move.id})
      second_move = first_move.children.first
      # third: guess move
      @game.play({:x => 5, :y => 6, :parent_move_id => second_move.id})
      # third: guess move 2 - should replace (5,6)
      @game.play({:x => 7, :y => 8, :parent_move_id => second_move.id})

      @game.moves.should == 1
      @game.detail.whose_turn.should == Game::WHITE
      @game.detail.reload
      @game.detail.last_move_id.should == first_move.id
      GameMove.find_all_by_game_detail_id(@game.detail.id).size.should == 3
      move = GameMove.last
      move.game_detail_id.should == @game.detail.id
      move.move_no.should == 3
      move.color.should == Game::BLACK
      move.x.should == 7
      move.y.should == 8
      move.player_id.should be_blank
      move.guess_player_id.should be_blank
      move.parent_id.should == second_move.id
    end
  end
end
