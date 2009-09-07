module UploadsHelper
  def show_masked_email?
    not session[:upload_email].nil?
  end
  
  def masked_email
    local_part, domain_name = session[:upload_email].split('@', 2)
    "#{'*' * local_part.length}@#{domain_name}"
  end
end