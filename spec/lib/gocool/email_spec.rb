require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Gocool::Email do
  it "should return true for valid email" do
    Gocool::Email.valid?('test@test.com').should be_true
  end
  
  it "should return true for invalid email" do
    pending "add matchers: be_false_or_nil" do
      Gocool::Email.valid?('test.com').should be_false_or_nil
      Gocool::Email.valid?('test@test').should be_false_or_nil
    end
  end
end