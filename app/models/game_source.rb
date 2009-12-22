class GameSource < ActiveRecord::Base
  STATUS_PARSE_SUCCESS = 'parse_success'
  STATUS_PARSE_FAILURE = 'parse_failure'

  UPLOAD_FILE = 'file'
  UPLOAD_SGF  = 'sgf'
  UPLOAD_URL  = 'url'

  belongs_to :game
  has_attached_file :upload

  default_scope :include => :game
  
  named_scope :with_hash, lambda { |hash|
    {:conditions => ["hash_code = ?", hash]}
  }
  
  named_scope :recent, :order => 'created_at DESC'

  named_scope :with_url_hash, lambda {|hash|
    {:conditions => ["source_type = ? and hash_code = ?", UPLOAD_URL, hash]}
  }

  def self.create_from_sgf data, sgf_game, hash_code = nil
    hash_code ||= Gocool::Md5.string_to_md5 data
    game_source = create!(:source_type => GameSource::UPLOAD_SGF, :data => data, :hash_code => hash_code)

    game = Game.new(:primary_source => game_source)
    game.load_parsed_game(sgf_game)
    game.save!

    temp_file = "/tmp/game_#{game_source.id}_#{rand(100)}.sgf"
    File.open(temp_file, "w") do |file|
      file.print data
    end

    game_source.upload = File.new temp_file
    game_source.game = game
    game_source.save!
    game_source
  end

  def self.create_from_url url, hash_code = nil
    open(url) do |file|
      hash_code ||= Gocool::Md5.string_to_md5 url
      game_source = create!(:source_type => GameSource::UPLOAD_URL, :source => url, :hash_code => hash_code)

      temp_file = "/tmp/game_#{game_source.id}_#{rand(100)}.sgf"
      File.open(temp_file, "w") do |to_file|
        to_file.print(file.readlines)
      end

      game = Game.new(:primary_source => game_source)
      game.load_parsed_game(SGF::Parser.parse_file(temp_file))
      game.save!

      game_source.upload = File.new temp_file
      game_source.game = game
      game_source.save!
      game_source
    end
  end

  def parse
    self.status = STATUS_PARSE_SUCCESS
    SGF::Parser.parse_file self.upload.path
  rescue SGF::ParseError => e
    self.status = STATUS_PARSE_FAILURE
    self.status_detail = e.message
    raise
  end

  def parse_and_save
    self.game = Game.new
    self.game.load_parsed_game(parse)
    self.game.primary_game_source_id = id
    self.game.save!
  ensure
    save!
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

    file_encoding = %x(/usr/bin/file -i #{self.upload.path}).strip

    if contains_not_recognizable_chars?(file_encoding)
      %x(cp #{self.upload.path} #{self.raw_file_path})
      convert_cmd = "#{ENV['ICONV_PATH']} -f gb18030 #{self.upload.path} > #{self.upload.path}.tmp"
      %x(#{convert_cmd} && cp #{self.upload.path}.tmp #{self.upload.path} && rm #{self.upload.path}.tmp)
    end
  end

  def contains_not_recognizable_chars? encoding
    encoding.include?('charset=') and not (encoding.include?('charset=us-ascii') or encoding.include?('charset=utf'))
  end
end
