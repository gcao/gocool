class Upload < ActiveRecord::Base 
  has_attached_file :upload
  
  validates_presence_of :email, :message => I18n.translate('upload.email_required')
  validates_presence_of :upload_file_name, :message => I18n.translate('upload.file_required')
end