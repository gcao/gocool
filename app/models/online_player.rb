class OnlinePlayer < ActiveRecord::Base
  belongs_to :player
  belongs_to :gaming_platform
  
  has_one :stat, :class_name => 'OnlinePlayerStat'

  has_many :opponents, :class_name => "OnlinePairStat", :foreign_key => 'player_id'
    
  default_scope :order => 'username'

  named_scope :with_games, :include => :games
  named_scope :on_platform, lambda {|platform| {:conditions => ["gaming_platform_id = ?", platform.id]} }
  named_scope :username_like, lambda {|username| {:conditions => ["username like ?", username.gsub('*', '%')]} }
  named_scope :include, lambda {|associations| {:include => associations} }

  def name
    self.username
  end

  def long_name
    s = self.username
    s << "(" << self.rank << ")" unless self.rank.blank?
    s
  end

  def games
    Game.on_platform(self.gaming_platform.name).black_id_or_white_id_is(self.id)
  end
  
  def self.find_or_create platform, username, rank
    player = on_platform(platform).find_by_username(username)
    unless player
      player = create!(:gaming_platform_id => platform.id, :username => username, :rank => rank)
      OnlinePlayerStat.create!(:online_player_id => player.id)
    end
    player
  end
  
  def self.search platform_name, username
    k = self
    k = k.on_platform(GamingPlatform.find_by_name(platform_name)) unless platform_name.blank?
    k = k.username_like(username) unless username.blank?
    k = k.include(:gaming_platform, :stat)
  end
end
