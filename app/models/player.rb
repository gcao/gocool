class Player < ActiveRecord::Base
  belongs_to :gaming_platform

  has_one :stat, :class_name => 'PlayerStat'

  has_many :opponents, :class_name => "PairStat"

  named_scope :on_platform, lambda {|platform|
    if platform.blank?
      {:conditions => ["players.gaming_platform_id is null"]}
    elsif platform.to_i == GamingPlatform::ALL
      {}
    else
      {:conditions => ["players.gaming_platform_id = ?", platform]}
    end
  }
  named_scope :name_like, lambda {|name| {:conditions => ["players.name like ?", name.gsub('*', '%')]} }

  named_scope :with_stat, :include => :stat
  named_scope :include, lambda {|associations| {:include => associations} }

  def self.find_or_create platform, name, rank
    player = on_platform(platform.nil_or.id).find_by_name(name)
    unless player
      player = create!(:gaming_platform_id => platform.nil_or.id, :name => name, :rank => rank)
      PlayerStat.create!(:player_id => player.id)
    end
    player
  end

  def self.search platform, name
    k = self
    k = k.on_platform(platform)
    k = k.name_like(name) unless name.blank?
    k.include(:gaming_platform, :stat)
  end

  def games
    Game.black_id_or_white_id_is(self.id)
  end
end
