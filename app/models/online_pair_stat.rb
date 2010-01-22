class OnlinePairStat < ActiveRecord::Base
  include AbstractPlayerStat

  belongs_to :player, :class_name => "OnlinePlayer", :foreign_key => :player_id
  belongs_to :opponent, :class_name => "OnlinePlayer", :foreign_key => :opponent_id

  default_scope :include => 'opponent'

  named_scope :opponent_name_like, lambda{ |name|
    { :conditions => ["online_players.username like ?", name] }
  }

  def self.find_or_create gaming_platform_id, player_id, opponent_id
    find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:gaming_platform_id => gaming_platform_id, :player_id => player_id, :opponent_id => opponent_id)
  end
end
