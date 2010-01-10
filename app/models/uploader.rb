class Uploader

  def process_files description, files
    uploads = files.map {|file| Upload.create!(:source_type => Upload::UPLOAD_FILE, :description => description, :file => file) }
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
      result.detail = "#{upload.file_file_name} is not a SGF file."
    elsif found = process_duplicate_upload(upload)
      result.found_upload = found
      result.status = UploadResult::FOUND
      result.detail = I18n.t('uploads.already_uploaded_detail')
    else
      upload.parse_and_save
      result.status = UploadResult::SUCCESS
    end
    result
  rescue SGF::ParseError => e
    result.status = UploadResult::SGF_ERROR
    result.detail = upload.status_detail
    result
  rescue => e
    result.status = UploadResult::ERROR
    result.detail = e.to_s
    result
  end

  def process_compressed_upload upload
    return upload unless upload.file_file_name =~ /\.zip$/i

    filename = upload.file_file_name
    cmd = "cd /tmp && rm -rf #{filename} && mkdir #{filename} && cd #{filename} && unzip #{upload.file.path}"
    puts cmd
    system(cmd)
    uploads = []
    Dir["/tmp/#{filename}/**/*"].each do |path|
      next if File.directory?(path)
      uploads << Upload.create!(:description => upload.description, :source_type => Upload::UPLOAD_FILE, :file => File.new(path))
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
