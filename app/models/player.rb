class Player < ActiveRecord::Base
  belongs_to :gaming_platform

  has_one :stat, :class_name => 'PlayerStat'

  has_many :opponents, :class_name => "PairStat"

  named_scope :on_platform, lambda {|platform|
    if platform
      {:conditions => ["players.gaming_platform_id = ?", platform.id]}
    else
      {:conditions => ["players.gaming_platform_id is null"]}
    end
  }
  named_scope :name_like, lambda {|name| {:conditions => ["players.name like ?", name.gsub('*', '%')]} }

  named_scope :with_stat, :include => :stat
  named_scope :include, lambda {|associations| {:include => associations} }

  def self.find_or_create platform, name, rank
    player = on_platform(platform).find_by_name(name)
    unless player
      player = create!(:gaming_platform_id => platform.nil_or.id, :name => name, :rank => rank)
      PlayerStat.create!(:player_id => player.id)
    end
    player
  end

  def self.search platform_name, name
    k = self
    k = k.on_platform(GamingPlatform.find_by_name(platform_name))
    k = k.name_like(name) unless name.blank?
    k.include(:gaming_platform, :stat)
  end

  def games
    Game.on_platform(nil).black_id_or_white_id_is(self.id)
  end
end
