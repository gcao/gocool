require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Upload do
  it "#parse should parse valid game and set status as parse_success" do
    u = Upload.create!(:email => 'test@test.com', :upload_file_name => 'simple.sgf')
    u.upload.stubs(:path).returns(File.expand_path(File.dirname(__FILE__) + "/../fixtures/sgf/simple.sgf"))
    u.parse
    u.reload
    u.status.should == 'parse_success'
  end
end