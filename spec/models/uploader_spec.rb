require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Uploader do
  before do
    @uploader = Uploader.new
  end

  it "process should save to upload table and return UploadResult object" do
    results = @uploader.process 'uploader@test.com', [File.new(File.dirname(__FILE__) + "/../fixtures/sgf/good.sgf")]
    results[0].status.should == UploadResult::SUCCESS

    upload = Upload.find_by_email('uploader@test.com')
    upload.upload_file_name.should == 'good.sgf'
  end

  it "process should be able to handle multiple files" do
    results = @uploader.process 'uploader@test.com', [
            File.new(File.dirname(__FILE__) + "/../fixtures/sgf/good.sgf"),
            File.new(File.dirname(__FILE__) + "/../fixtures/sgf/bad.sgf")
    ]
    results[0].status.should == UploadResult::SUCCESS
    results[0].upload.upload_file_name.should == 'good.sgf'
    results[1].status.should == UploadResult::ERROR
    results[1].upload.upload_file_name.should == 'bad.sgf'

    Upload.find_all_by_email('uploader@test.com').size.should == 2
  end

  it "process should be able to handle zip file" do
    results = @uploader.process 'uploader@test.com', [File.new(File.dirname(__FILE__) + "/../fixtures/sgf/good_bad.zip")]

    results[0].status.should == UploadResult::ERROR
    results[0].upload.upload_file_name.should == 'bad.sgf'
    results[1].status.should == UploadResult::SUCCESS
    results[1].upload.upload_file_name.should == 'good.sgf'

    Upload.find_all_by_email('uploader@test.com').size.should == 2
  end
end
