module CoolGames
  class Player < ActiveRecord::Base
    belongs_to :gaming_platform

    set_table_name "cg_players"

    has_one :stat, :class_name => 'PlayerStat', :dependent => :destroy
    has_many :opponents, :class_name => "PairStat", :dependent => :destroy

    scope :on_platform, lambda {|platform|
      if platform.blank?
        {:conditions => ["gaming_platform_id is null"]}
      elsif platform.is_a? GamingPlatform
        {:conditions => ["gaming_platform_id = ?", platform.id]}
      elsif platform.to_i == GamingPlatform::ALL
        {}
      else
        {:conditions => ["gaming_platform_id = ?", platform]}
      end
    }
    scope :name_like, lambda {|name| {:conditions => ["name like ?", name.gsub('*', '%')]} }

    scope :with_stat, :include => :stat
    scope :include, lambda {|*associations| {:include => associations} }

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
      k.include(:gaming_platform, :stat)
    end

    after_create do
      PlayerStat.create!(:player_id => id)
    end

    def games
      Game.where("black_id = ? or white_id = ?", self.id, self.id)
    end

    before_destroy do
      ActiveRecord::Base.connection.execute <<-SQL
        delete from pair_stats where opponent_id = #{self.id}
      SQL
    end

    def user
      return unless gaming_platform == GamingPlatform.gocool and parent_id > 0

      @user ||= User.find(parent_id)
    #rescue ActiveRecord::RecordNotFound
    #  # Ignore not found error
    #  nil
    end
  end
end
