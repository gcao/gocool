class Upload < ActiveRecord::Base 
  STATUS_PARSE_SUCCESS = 'parse_success'
  STATUS_PARSE_FAILURE = 'parse_failure'
  
  has_one :game_source
  has_attached_file :upload
  
  validates_presence_of :upload_file_name, :message => I18n.translate('upload.file_required')
  
  def game
    game_source.try(:game)
  end
  
  def parse
    game = SGF::Parser.parse_file self.upload.path
    self.status = STATUS_PARSE_SUCCESS
  rescue SGF::ParseError
    self.status = STATUS_PARSE_FAILURE
  ensure
    self.save!
  end
  
  def after_save
    convert_to_utf
  end
  
  def convert_to_utf
    file_encoding = %x(file -i #{self.upload.path}).strip
    
    if contains_not_recognizable_chars?(file_encoding)
      %x(cp #{self.upload.path} #{self.raw_file_path})
      convert_cmd = "#{ENV['ICONV_PATH']} -f gb18030 #{self.upload.path} > #{self.upload.path}.tmp"
      %x(#{convert_cmd} && cp #{self.upload.path}.tmp #{self.upload.path} && rm #{self.upload.path}.tmp)
    end
  end
  
  def contains_not_recognizable_chars? encoding
    not (encoding.include?('charset=us-ascii') or encoding.include?('charset=utf'))
  end
  
  def raw_file_path
    paths = self.upload.path.split('/')
    paths[-1] = 'RAW_' + paths[-1]
    paths.join('/')
  end
end