require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe GamesController do
  integrate_views
  
  describe "index" do
    it "should not run search if op is not search" do
      Game.expects(:search).never
      
      get :index, :first_player => 'first'
      
      response.should be_success
    end
    
    it "should return list of games on valid request" do
      Game.create!(:black_name => 'first_player', :white_name => 'second_player', :name => 'first vs second')
      Game.create!(:black_name => 'second_player', :white_name => 'white_player', :name => 'second vs first')
      
      get :index, :op => 'search', :first_player => 'first'
      
      response.should be_success
      response.body.should have_tag("td", "first vs second")
      response.body.should have_tag("td", "second vs first")
    end
    
    it "should return first player is required error if first player is blank" do
      get :index, :op => 'search', :first_player => 'first'
      
      response.should be_success
      response.body.should have_tag("div.error", I18n.t('games.first_player_is_required'))
    end
  end
end