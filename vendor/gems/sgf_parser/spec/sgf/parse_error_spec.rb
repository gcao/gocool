require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe ParseError do
    it "message should return content up to the bad input" do
      error = ParseError.new("(;AB]", 4)
      error.message.should include("(;AB] <=== SGF parse error occurred here")
    end
  end
end