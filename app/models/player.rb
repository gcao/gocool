class Player < ActiveRecord::Base
  belongs_to :gaming_platform

  has_one :stat, :class_name => 'PlayerStat', :dependent => :destroy
  has_many :opponents, :class_name => "PairStat", :dependent => :destroy

  has_one :user, :class_name => 'User', :foreign_key => "qiren_player_id"

  scope :on_platform, lambda {|platform|
    if platform.blank?
      {:conditions => ["players.gaming_platform_id is null"]}
    elsif platform.is_a? GamingPlatform
      {:conditions => ["players.gaming_platform_id = ?", platform.id]}
    elsif platform.to_i == GamingPlatform::ALL
      {}
    else
      {:conditions => ["players.gaming_platform_id = ?", platform]}
    end
  }
  scope :name_like, lambda {|name| {:conditions => ["players.name like ?", name.gsub('*', '%')]} }

  scope :with_stat, :include => :stat
  scope :include, lambda {|associations| {:include => associations} }

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

  def after_create
    PlayerStat.create!(:player_id => id)
  end

  def games
    Game.where("black_id = ? or white_id = ?", self.id, self.id)
  end

  def before_destroy
    ActiveRecord::Base.connection.execute <<-SQL
      delete from pair_stats where opponent_id = #{self.id}
    SQL
  end
end
