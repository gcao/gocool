module CoolGames
  class Upload < ActiveRecord::Base

    set_table_name "cg_uploads"

    STATUS_PARSE_SUCCESS = 'parse_success'
    STATUS_PARSE_FAILURE = 'parse_failure'

    UPLOAD_FILE = 'file'
    UPLOAD_SGF  = 'sgf'
    UPLOAD_URL  = 'url'

    belongs_to :game
    has_attached_file :file

    scope :with_hash, lambda { |hash|
      {:conditions => ["hash_code = ?", hash]}
    }

    scope :with_description, lambda { |description|
      if description.blank?
        {}
      else
        {:conditions => ["uploads.description like ?", "%#{description.strip}%"]}
      end
    }

    scope :recent, :order => 'created_at DESC'

    scope :between, lambda {|from, to|
      if from
        if to
          conditions = ["date(uploads.created_at) >= ? and date(uploads.created_at) <= ?", from, to]
        else
          conditions = ["date(uploads.created_at) >= ?", from]
        end
      elsif to
        conditions = ["date(uploads.created_at) <= ?", to]
      end
      if conditions
        { :conditions => conditions }
      end
    }

    def self.create! attributes
      if attributes[:uploader_id].nil? and user = Thread.current[:user]
        attributes.merge! :uploader => user.username, :uploader_id => user.id
      end
      super attributes
    end

    def self.recent_7_days
      where("uploads.created_at > ?", Date.today - 6.days)
    end

    def self.today
      where("uploads.created_at > ?", Date.today)
    end

    def self.create_from_sgf description, data, sgf_game, hash_code = nil
      hash_code ||= Gocool::Md5.string_to_md5 data
      upload = create!(:source_type => Upload::UPLOAD_SGF, :description => description, :data => data, :hash_code => hash_code)

      game = Game.new(:primary_source => upload)
      game.load_parsed_game(sgf_game)
      game.save!

      temp_file = "/tmp/game_#{upload.id}_#{rand(100)}.sgf"
      File.open(temp_file, "w") do |file|
        file.print data
      end

      upload.file = File.new temp_file
      upload.game = game
      upload.save!
      upload
    end

    def self.create_from_url description, url, hash_code = nil
      open(url) do |file|
        hash_code ||= Gocool::Md5.string_to_md5 url

        temp_file = "/tmp/game_#{rand(100000)}.sgf"
        File.open(temp_file, "w") do |to_file|
          to_file.print(file.readlines)
        end
        upload = create!(:source_type => Upload::UPLOAD_URL,
                         :description => description,
                         :source => url,
                         :file => File.new(temp_file),
                         :hash_code => hash_code)

        upload.parse_and_save
        upload
      end
    end

    def parse
      self.status = STATUS_PARSE_SUCCESS
      SGF::Parser.parse_file self.file.path
    rescue SGF::ParseError => e
      self.status = STATUS_PARSE_FAILURE
      self.status_detail = e.message
      raise
    end

    def parse_and_save
      self.game = Game.new
      self.game.load_parsed_game(parse)
      self.game.primary_upload_id = id
      self.game.save!
    ensure
      save!
    end

    def raw_file_path
      paths = self.file.path.split('/')
      paths[-1] = 'RAW_' + paths[-1]
      paths.join('/')
    end

    before_save do
      @file_changed = self.changed.include?("file_file_name") || self.changed.include?("file_file_size") || self.changed.include?("file_updated_at")
      true
    end

    after_save do
      if @file_changed
        #create_symbolic_link if is_sgf?
        convert_to_utf
      end
    end

    after_create do
      convert_to_utf
    end

    def update_hash_code
      self.hash_code = Gocool::Md5.file_to_md5(self.file.path)
    end

    def is_sgf?
      file and file.path and file.path.downcase.include?(".sgf")
    end

    DESCRIPTION_PATTERN = /"upload_time"=>"([^"]+)", .*"subject"=>"([^"]*)"/

    def description
      desc = attributes['description']
      if desc =~ DESCRIPTION_PATTERN
        "#{$1} #{$2}"
      else
        desc
      end
    end

    def reload_game_from_url
      return unless source_type == UPLOAD_URL

      open(source) do |new_data|
        File.open(self.file.path, "w") do |to_file|
          to_file.print(new_data.readlines)
        end
        convert_to_utf
        game.primary_upload_id = id if game.primary_upload_id.nil?
        game.load_parsed_game(parse)
        game.save!
      end
    end

    private

    def create_symbolic_link
      `ln -F -s #{self.file.path} #{File.dirname(self.file.path)}/1.sgf`
    end

    def convert_to_utf
      return unless is_sgf? and File.exists?(file.path)

      file_encoding = %x(/usr/bin/file -i #{self.file.path}).strip

      if contains_not_recognizable_chars?(file_encoding)
        %x(cp #{self.file.path} #{self.raw_file_path})

        contents = File.open(self.file.path).read
        output = Iconv.conv('utf8', 'gb18030', contents)
        File.open(self.file.path, 'w') do |file|
          file.write(output)
        end
      end
    end

    def contains_not_recognizable_chars? encoding
      encoding.include?('charset=') and not (encoding.include?('charset=us-ascii') or encoding.include?('charset=utf'))
    end
  end
end
