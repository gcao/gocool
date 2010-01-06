require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe UploadsController do
  describe "create" do
    it "should take uploaded files" do
      post :create, :upload => {:upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}

      upload = assigns(:upload)
      response.should redirect_to upload_url(upload.id)
    end
  end
end
