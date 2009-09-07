require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UploadsHelper do
  it "show_masked_email? should return true if email is found in session" do
    helper.expects(:session).returns({:upload_email => 'test@test.com'})
    helper.show_masked_email?.should be_true
  end
  
  it "masked_email should return email with local part masked" do
    helper.expects(:session).returns({:upload_email => 'test@test.com'})
    helper.masked_email.should == '****@test.com'
  end
end