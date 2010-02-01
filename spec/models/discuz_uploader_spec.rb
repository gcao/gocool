require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe DiscuzUploader do
  before do
    @uploader = DiscuzUploader.new
  end

  it "should upload sgf attachment" do
    post = Discuz::Post.new(:author => 'testuser', :authorid => 123, :message => "")
    attachment = Discuz::Attachment.new(:filename => 'good.sgf')
    attachment.expects(:path).returns(File.expand_path(File.dirname(__FILE__) + "/../fixtures/sgf/discuz_attachment.sgf"))
    post.attachments = [attachment]
    uploads = @uploader.upload post

    uploads[0].uploader.should == 'testuser'
    uploads[0].uploader_id.should == User.find_by_external_id(123).id
  end
end
