class Uploader

  def process email, files
    uploads = files.map {|file| Upload.create!(:email => email, :upload => file) }
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
    if not upload.is_sgf?
      result.status = UploadResult::VALIDATION_ERROR
      result.detail = "#{upload.upload_file_name} is not a SGF file."
    elsif found = process_duplicate_upload(upload)
      result.status = UploadResult::FOUND
      result.detail = I18n.t('uploads.already_uploaded_detail')
      result.existing_upload = found
    else
      upload.save_game
      result.status = UploadResult::SUCCESS
    end
    result
  rescue => e
    result.status = UploadResult::ERROR
    result.detail = e.to_s
    result
  end

  def process_compressed_upload upload
    return upload unless upload.upload_file_name =~ /\.zip$/i

    filename = upload.upload_file_name
    cmd = "cd /tmp && rm -rf #{filename} && mkdir #{filename} && cd #{filename} && unzip #{upload.upload.path}"
    puts cmd
    system(cmd)
    uploads = []
    Dir["/tmp/#{filename}/*"].each do |path|
      uploads << Upload.create!(:email => upload.email, :upload => File.new(path))
    end
    upload.delete
    uploads
  end
  
  def process_duplicate_upload upload
    upload.update_hash_code
    if found_upload = Upload.with_hash(upload.hash_code).first
      upload.delete
      found_upload
    end
  end
  
end
