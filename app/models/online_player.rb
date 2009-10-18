class OnlinePlayer < ActiveRecord::Base
  belongs_to :player
  belongs_to :gaming_platform
  
  has_one :online_player_game
  has_one :online_player_won_game
  has_one :online_player_lost_game
    
  default_scope :order => 'username'

  named_scope :with_games, :include => :games
  named_scope :on_platform, lambda {|platform| {:include => :gaming_platform, :conditions => ["gaming_platform_id = ?", platform.id]} }
  named_scope :username_like, lambda {|username| {:conditions => ["username like ?", "%#{username}%"]} }
  
  def self.find_or_create platform, username
    on_platform(platform).find_by_username(username) || create!(:gaming_platform_id => platform.id, :username => username)
  end
  
  def self.search platform_name, username, page_no = 0
    k = self
    k = k.on_platform(GamingPlatform.find_by_name(platform_name)) unless platform_name.blank?
    k = k.username_like(username) unless username.blank?
    k.find(:all, :include => [:online_player_game, :online_player_won_game, :online_player_lost_game])
  end
end
