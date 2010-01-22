class PairStat < ActiveRecord::Base
  include AbstractPlayerStat, AbstractPairStat
  
  belongs_to :player, :class_name => "Player", :foreign_key => :player_id
  belongs_to :opponent, :class_name => "Player", :foreign_key => :opponent_id

  default_scope :include => 'opponent'

  named_scope :opponent_name_like, lambda{ |name|
    { :conditions => ["players.full_name like ?", name] }
  }
end
