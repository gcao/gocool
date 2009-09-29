require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Gocool::Md5 do
  it "file_to_md5" do
    filename = File.dirname(__FILE__) + "/../../fixtures/sgf/good.sgf"
    Gocool::Md5.file_to_md5(filename).should == %x(/usr/bin/tr -d [:space:] < #{filename}  | md5).strip
  end
  
  it "string_to_md5" do
    s = "ABCDEF"
    Gocool::Md5.string_to_md5(s).should == %x(echo #{s} | /usr/bin/tr -d [:space:] | md5).strip
  end
  
  it "string_to_md5 should ignore spaces" do
    Gocool::Md5.string_to_md5('ABC').should == Gocool::Md5.string_to_md5(" A B C \n")
  end
  
  it "file_to_md5 and string_to_md5 should produce same result if content is the same" do
    s = "ABCDEF"
    f = Tempfile.new('test')
    f.print s
    f.print "   \n"
    f.close
    Gocool::Md5.string_to_md5(s).should == Gocool::Md5.file_to_md5(f.path)
  end
end