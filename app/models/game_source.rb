class GameSource < ActiveRecord::Base
  STATUS_PARSE_SUCCESS = 'parse_success'
  STATUS_PARSE_FAILURE = 'parse_failure'

  UPLOAD_TYPE = 'upload'
  PASTIE_TYPE = 'pastie'

  belongs_to :game

  default_scope :include => :game
  
  named_scope :with_hash, lambda { |hash|
    {:conditions => ["hash_code = ?", hash]}
  }
  
  named_scope :recent, :order => 'created_at DESC'

  def parse
    self.status = STATUS_PARSE_SUCCESS
    SGF::Parser.parse_file self.upload.path
  rescue SGF::ParseError => e
    self.status = STATUS_PARSE_FAILURE
    self.status_detail = e.message
    raise
  ensure
    self.save!
  end

  def raw_file_path
    paths = self.upload.path.split('/')
    paths[-1] = 'RAW_' + paths[-1]
    paths.join('/')
  end

  def before_save
    @file_changed = self.changed.include?("upload_file_name") || self.changed.include?("upload_file_size") || self.changed.include?("upload_updated_at")
    true
  end

  def after_save
    super

    if @file_changed
      convert_to_utf
    end
  end

  def update_hash_code
    self.hash_code = Gocool::Md5.file_to_md5(self.upload.path)
  end

  def is_sgf?
    upload and upload.path.downcase.include?(".sgf")
  end

  private

  def convert_to_utf
    return unless is_sgf? and File.exists?(upload.path)

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
end
