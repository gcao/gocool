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
    game1 = Game.create!(:black_name => 'first_player', :white_name => 'second_player', :name => 'first vs second')
    game2 = Game.create!(:black_name => 'second_player', :white_name => 'first_player', :name => 'second vs first')
    
    Game.search(nil, 'first', nil).should == [game1, game2]
  end
end