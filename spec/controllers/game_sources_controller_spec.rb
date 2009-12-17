require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe GameSourcesController do
  describe "create" do
    it "should take uploaded files" do
      post :create, :upload => {:upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}

      response.should be_success

      game_source = assigns(:game_source)
      response.should redirect_to game_source_url(game_source.id)
    end
  end
end
