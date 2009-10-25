class Uploader
  def process email, files
    files.map do |file|
      result = UploadResult.new
      result.status = I18n.t('uploads.status.success')
      upload = Upload.new(:email => email, :upload => file)
      if upload.valid?
        process_valid_upload upload, result
      else
        result.status = I18n.t('uploads.status.validation_error')
        result.detail = upload.errors.map(&:to_s).join("<br/> ")
      end
      result.upload = upload
      result
    end
  end
  
  private
  
  def process_valid_upload upload, result
    upload.save!
  
    if found = process_duplicate_upload(upload)
      result.status = I18n.t('uploads.status.already_uploaded')
      result.detail = I18n.t('uploads.already_uploaded_detail')
      result.existing_upload = found
    else
      upload.save_game
    end
  rescue => e
    result.status = I18n.t('uploads.status.error')
    result.detail = e.to_s
  end
  
  def process_duplicate_upload upload
    upload.update_hash_code
    if found_upload = Upload.with_hash(upload.hash_code).first
      upload.delete
      found_upload
    end
  end
  
end