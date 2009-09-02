require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe UploadsController do
  integrate_views

  describe "create" do
    it "should create upload with valid params" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/simple.sgf', 'text/plain')}
      
      response.should be_success
      upload = Upload.find_by_email('test@test.com')
      upload.should_not be_blank
      upload.upload.url.should =~ %r(^/system/uploads/1/original/simple.sgf)
    end
    
    it "should format email before save" do
      post :create, :upload => {:email => ' TEST@TEST.COM ', :upload => fixture_file_upload('/sgf/simple.sgf', 'text/plain')}
      
      response.should be_success
      assigns(:upload).email.should == 'test@test.com'
    end
    
    it "should create multiple uploads with multiple files" do
      post :create, :upload => {:email => 'test@test.com', 
        :upload => fixture_file_upload('/sgf/simple.sgf', 'text/plain'), 
        :upload_234 => fixture_file_upload('/sgf/test.sgf', 'text/plain')}
      
      response.should be_success
      uploads = Upload.find_all_by_email('test@test.com')
      uploads.size.should == 2
    end
    
    it "should show the uploaded game" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/simple.sgf', 'text/plain')}
      
      response.should be_success
      response.should render_template(:show)
      response.should include_text("/system/uploads/1/original/simple.sgf")
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
  
  describe "search" do
    it "should show uploads uploaded by email" do
      upload = Upload.create!(:email => 'test1@test.com', :upload_file_name => 'test.sgf')
      
      get :search, :email => 'test1@test.com'
      
      response.should be_success
      response.should render_template(:search)
      assigns(:uploads).should == [upload]
    end
    
    it "should be case insensitive" do
      upload = Upload.create!(:email => 'test1@test.com', :upload_file_name => 'test.sgf')
      
      get :search, :email => ' TEST1@TEST.COM '
      
      response.should be_success
      assigns(:uploads).should == [upload]
    end
  end

end