class Upload < ActiveRecord::Base 
  STATUS_PARSE_SUCCESS = 'parse_success'
  STATUS_PARSE_FAILURE = 'parse_failure'
  
  has_one :game_source
  has_attached_file :upload
  
  default_scope :order => 'created_at DESC'
  
  named_scope :with_hash, lambda { |hash|
    {:conditions => ["hash_code = ?", hash]}
  }
  
  validates_presence_of :upload_file_name, :message => I18n.translate('upload.file_required')
  
  def game
    game_source.try(:game)
  end
  
  def parse
    self.status = STATUS_PARSE_SUCCESS
    SGF::Parser.parse_file self.upload.path
  rescue
    self.status = STATUS_PARSE_FAILURE
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
    
    return unless File.exists?(self.upload.path)

    if @file_changed
      convert_to_utf
    end
  end
  
  def update_hash_code
    self.hash_code = Gocool::Md5.file_to_md5(self.upload.path)
  end
  
  def save_game
    game = Game.new
    game.load_parsed_game(self.parse)
    game.save!
    
    game_source = GameSource.new
    game_source.game = game
    game_source.source_type = GameSource::UPLOAD_TYPE
    game_source.source = self.email
    game_source.upload_id = self.id
    game_source.save!
  end
  
  private
  
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
end