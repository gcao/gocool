class Upload < ActiveRecord::Base 
  STATUS_PARSE_SUCCESS = 'parse_success'
  STATUS_PARSE_FAILURE = 'parse_failure'
  
  has_attached_file :upload
  
  validates_presence_of :email, :message => I18n.translate('upload.email_required')
  validates_presence_of :upload_file_name, :message => I18n.translate('upload.file_required')
  
  def parse
    game = SGF::Parser.parse_file self.upload.path
    self.status = STATUS_PARSE_SUCCESS
  rescue SGF::ParseError
    self.status = STATUS_PARSE_FAILURE
  ensure
    self.save!
  end
end