class OnlinePairStat < ActiveRecord::Base
  include AbstractPlayerStat, AbstractPairStat

  belongs_to :player, :class_name => "OnlinePlayer", :foreign_key => :player_id
  belongs_to :opponent, :class_name => "OnlinePlayer", :foreign_key => :opponent_id

  default_scope :include => 'opponent'

  named_scope :opponent_name_like, lambda{ |name|
    { :conditions => ["online_players.username like ?", name] }
  }
end
