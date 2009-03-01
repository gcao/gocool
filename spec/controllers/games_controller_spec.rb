require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe GamesController do
  
  it "#index shows list of games" do
    get :index
    
    response.code.should == "200"
  end
end