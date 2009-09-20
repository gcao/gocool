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

    it "should remain on the paste page with error if email is not given" do
      post :create, :pastie => {:email => nil, :data => "(;GM[1]FF[3]GN[White (W) vs. Black (B)];)"}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("email.required"))
    end
    
    it "should remain on the paste page with error if SGF content is not given" do
      post :create, :pastie => {:email => 'test@test.com'}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("pastie.data_required"))
    end
    
    it "should create game on valid SGF" do
      post :create, :pastie => {:email => 'test@test.com', :data => "(;GM[1]FF[3]GN[White (W) vs. Black (B)];)"}
      
      response.should be_success
      
      game_data = assigns(:game_data)
      game_data.game.should_not be_nil
      game_data.game.name.should == "White (W) vs. Black (B)"
    end
    
    it "should remain on the paste page with error if SGF content is invalid" do
      post :create, :pastie => {:email => nil, :data => "INVALID SGF"}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should have_tag("div.error")
    end

  end
end