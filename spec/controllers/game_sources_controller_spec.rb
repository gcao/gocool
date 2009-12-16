require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe GameSourcesController do
  describe "index" do
    it "should redirect to login page if not logged in" do
      get :index

      response.should redirect_to login_url
    end
  end

  describe "create" do
    it "should take uploaded files" do
      post :create, :upload => {:upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}

      response.should be_success
    end
  end
end
