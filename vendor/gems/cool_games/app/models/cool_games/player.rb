module CoolGames
  class Player
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :gaming_platform
    #has_one :stat, :class_name => 'PlayerStat', :dependent => :destroy
    #has_many :opponents, :class_name => "PairStat", :dependent => :destroy

    field "parent_id"    , type: String
    field "first_name"   , type: String
    field "last_name"    , type: String
    field "name"         , type: String
    field "is_amateur"   , type: Boolean
    field "rank"         , type: String
    field "sex"          , type: Integer
    field "birth_year"   , type: Integer
    field "birthday"     , type: Date
    field "birth_place"  , type: String
    field "website"      , type: String
    field "email"        , type: String
    field "description"  , type: String
    field "registered_at", type: Date
    field "updated_by"   , type: String

    scope :on_platform, lambda {|platform|
      if platform.blank?
        #{:conditions => ["gaming_platform_id is null"]}
        where(gaming_platform: nil)
      elsif platform.is_a? GamingPlatform
        #{:conditions => ["gaming_platform_id = ?", platform.id]}
        where(gaming_platform: platform)
      elsif platform.to_i == GamingPlatform::ALL
        #{}
        where()
      else
        #{:conditions => ["gaming_platform_id = ?", platform]}
        where(gaming_platform: platform)
      end
    }
    #scope :name_like, lambda {|name| {:conditions => ["name like ?", name.gsub('*', '%')]} }
    scope :name_like, where(name: Regexp.new(name.gsub('*', '.*')))

    #scope :with_stat, :include => :stat
    #scope :include, lambda {|*associations| {:include => associations} }

    def self.find_or_create platform, name, rank
      player = on_platform(platform).find_by_name(name)
      unless player
        gaming_platform_id = platform.id if platform
        player = create!(:gaming_platform_id => gaming_platform_id, :name => name, :rank => rank)
      end
      player
    end

    def self.search platform, name
      k = self
      k = k.on_platform(platform)
      k = k.name_like(name) unless name.blank?
      #k.include(:gaming_platform, :stat)
    end

    after_create do
      #PlayerStat.create!(:player_id => id)
    end

    def games
      #Game.where("black_id = ? or white_id = ?", self.id, self.id)
      Game.any_of({black_id: id}, {white_id: id})
    end

    before_destroy do
      #ActiveRecord::Base.connection.execute <<-SQL
      #  delete from pair_stats where opponent_id = #{self.id}
      #SQL
    end

    def user
      return unless gaming_platform == GamingPlatform.gocool and parent_id.blank?

      @user ||= User.find(parent_id)
    #rescue ActiveRecord::RecordNotFound
    #  # Ignore not found error
    #  nil
    end
  end
end
