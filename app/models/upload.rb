class Upload < ActiveRecord::Base 
  # has_attached_file :upload
  has_attached_file :upload, :storage => :s3,
    :s3_credentials => "/etc/gocool/s3.yml",
    :bucket => Gocool::S3.wrap_bucket_name('gocool_uploads')
  
  validates_presence_of :email, :message => I18n.translate('upload.email_required')
  validates_presence_of :upload_file_name, :message => I18n.translate('upload.file_required')
end