require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe UploadsController do
  integrate_views
  
  describe "index" do
    describe "remember email" do
      it "should show remembered email and mask local part" do
        session[:upload_email] = 'test@test.com'
        
        get :index
        
        response.should be_success
        response.should have_tag('span', :text => /\*\*\*\*@test\.com/)
      end
    end
  end

  describe "create" do
    it "should create upload with valid params" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}
      
      response.should be_success
      upload = Upload.find_by_email('test@test.com')
      upload.should_not be_blank
      upload.upload.url.should =~ %r(^/system/uploads/1/original/good.sgf)
    end
    
    it "should format email before save" do
      post :create, :upload => {:email => ' TEST@TEST.COM ', :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}
      
      response.should be_success
      assigns(:upload).email.should == 'test@test.com'
    end
    
    it "should remember formatted email in session" do
      post :create, :upload => {:email => ' TEST@TEST.COM ', :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}
      
      session[:email].should == 'test@test.com'
    end
    
    it "should use remembered email if email is missing" do
      session[:email] = 'test@test.com'

      post :create, :upload => {:upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}      

      response.should be_success
      upload = Upload.find_by_email('test@test.com')
      upload.should_not be_blank
      upload.upload.url.should =~ %r(^/system/uploads/1/original/good.sgf)
    end
    
    it "should create multiple uploads with multiple files" do
      post :create, :upload => {:email => 'test@test.com', 
        :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain'), 
        :upload_234 => fixture_file_upload('/sgf/good1.sgf', 'text/plain')}
      
      response.should be_success
      uploads = Upload.find_all_by_email('test@test.com')
      uploads.size.should == 2
    end
    
    it "should show the uploaded game" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}
      
      response.should be_success
      response.should render_template(:show)
      response.should include_text("/system/uploads/1/original/good.sgf")
    end
    
    it "should remain on the upload page with error if email is not given" do
      post :create, :upload => {:email => nil, :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("email.required"))
    end
    
    it "should remain on the upload page with error if file is not given" do
      post :create, :upload => {:email => 'test@test.com'}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("upload.file_required"))
    end
    
    it "should remain on the upload page with error if file is not attached" do
      post :create, :upload => {:email => 'test@test.com', :upload => nil}
      
      response.should be_success
      response.should render_template(:index)
      response.body.should include(I18n.translate("upload.file_required"))
    end
    
    it "should create game on valid SGF" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/good.sgf', 'text/plain')}
      
      response.should be_success
      
      upload = assigns(:upload)
      upload.game.should_not be_nil
      upload.game_source.should_not be_nil
    end
    
    it "should convert from GB to UTF" do
      post :create, :upload => {:email => 'test@test.com', :upload => fixture_file_upload('/sgf/chinese_gb.sgf', 'text/plain')}
      
      response.should be_success
      
      upload = assigns(:upload)
      upload.game.name.should == "遇仙谱"
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