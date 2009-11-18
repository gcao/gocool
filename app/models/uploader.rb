class Uploader
#  def process email, files
#    raise ArgumentError.new if email.nil?
#    files.map do |file|
#      result = UploadResult.new
#      result.status = UploadResult::SUCCESS
#      upload = Upload.new(:email => email, :upload => file)
#      if upload.valid?
#        process_valid_upload upload, result
#      else
#        result.status = UploadResult::VALIDATION_ERROR
#        result.detail = upload.errors.map(&:to_s).join("<br/> ")
#      end
#      result.upload = upload
#      result
#    end
#  end

  def process email, files
    uploads = files.map {|file| Upload.create!(:email => email, :upload => file)}
    uploads = uploads.inject([]) do |new_uploads, upload|
      new_uploads << process_compressed_upload(upload)
    end.flatten
    uploads.map do |upload|
      process_upload upload
    end
  end
  
  private

  def process_upload upload
    result = UploadResult.new
    result.upload = upload
    if found = process_duplicate_upload(upload)
      result.status = UploadResult::FOUND
      result.detail = I18n.t('uploads.already_uploaded_detail')
      result.existing_upload = found
    else
      result.status = UploadResult::SUCCESS
    end
    result
  rescue => e
    result = UploadResult.new
    result.upload = upload
    result.status = UploadResult::ERROR
    result.detail = e.to_s
    result
  end
  
#  def process_valid_upload upload, result
#    upload.save!
#
#    if found = process_duplicate_upload(upload)
#      result.status = UploadResult::FOUND
#      result.detail = I18n.t('uploads.already_uploaded_detail')
#      result.existing_upload = found
#    else
#      upload.save_game
#    end
#  rescue => e
#    result.status = UploadResult::ERROR
#    result.detail = e.to_s
#  end

  def process_compressed_upload upload
    if upload.path =~ /\.zip$/i
      filename = upload.filename
      cmd = "cd /tmp && rm -rf #{filename} && mkdir #{filename} && cd #{filename} && unzip #{upload.path}"
      system(cmd)
      uploads = []
      Dir["/tmp/#{filename}/*"].each do |path|
        uploads << Upload.create!(:email => upload.email, :upload => File.new(path))
      end
      upload.delete!
      uploads
    else
      upload
    end
  end
  
  def process_duplicate_upload upload
    upload.update_hash_code
    if found_upload = Upload.with_hash(upload.hash_code).first
      upload.delete
      found_upload
    end
  end
  
end
