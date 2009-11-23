module UploadsHelper
  def show_masked_email?
    not session[:upload_email].nil?
  end
  
  def masked_email
    local_part, domain_name = session[:upload_email].split('@', 2)
    "#{'*' * local_part.length}@#{domain_name}"
  end

  def display_upload_status upload_result
    case upload_result.status
      when UploadResult::SUCCESS then t('uploads.status.success')
      when UploadResult::VALIDATION_ERROR then t('uploads.status.validation_error')
      when UploadResult::ERROR then t('uploads.status.error')
      when UploadResult::FOUND then t('uploads.status.already_uploaded')
      when UploadResult::SGF_ERROR then t('uploads.status.parse_error')
      else status
    end
  end

  def display_upload_detail upload_result
    upload_result.detail
  end
end
