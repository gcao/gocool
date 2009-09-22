require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Upload do
  it "#parse should parse valid game and set status as parse_success" do
    u = Upload.create!(:email => 'test@test.com', :upload_file_name => 'good.sgf')
    u.upload.stubs(:path).returns(File.expand_path(File.dirname(__FILE__) + "/../fixtures/sgf/good.sgf"))
    u.parse
    u.reload
    u.status.should == 'parse_success'
  end
  
  it "#parse should set status as parse_failure on invalid game" do
    u = Upload.create!(:email => 'test@test.com', :upload_file_name => 'bad.sgf')
    u.upload.stubs(:path).returns(File.expand_path(File.dirname(__FILE__) + "/../fixtures/sgf/bad.sgf"))
    u.parse
    u.reload
    u.status.should == 'parse_failure'
  end
end