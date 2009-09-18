require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe PastiesController do
  integrate_views
  
  describe "index" do
  end
  
  describe "create" do
    it "should create game data with valid params" do
      data = "(;GM[1]FF[3]GN[White (W) vs. Black (B)];)"

      post :create, :pastie => {:email => 'test@test.com', :data => data}
      
      response.should be_success
      game_data = GameData.find_by_source('test@test.com')
      game_data.data.should == data
    end
  end
end