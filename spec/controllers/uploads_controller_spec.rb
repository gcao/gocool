require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe UploadsController do
  integrate_views

  describe "create" do
    it "should create upload with valid params" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/simple.sgf', 'text/plain')}
      
      response.should be_success
      response.should render_template(:create)
      upload = Upload.find_by_email('test@test.com')
      upload.should_not be_blank
      upload.upload.url.should =~ %r(^/system/uploads/1/original/simple.sgf)
    end
    
    it "should remain on the upload page with error if email is not given" do
      post :create, :upload => {:email => nil, :upload => fixture_file_upload('/sgf/simple.sgf', 'text/plain')}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("upload.email_required"))
    end
    
    it "should remain on the upload page with error if file is not attached" do
      post :create, :upload => {:email => 'test@test.com', :upload => nil}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("upload.file_required"))
    end
  end

end