class PairStat < ActiveRecord::Base
  include AbstractPlayerStat
  
  belongs_to :player, :class_name => "Player", :foreign_key => :player_id
  belongs_to :opponent, :class_name => "Player", :foreign_key => :opponent_id

  default_scope :include => 'opponent'

  named_scope :opponent_name_like, lambda{ |name|
    { :conditions => ["players.full_name like ?", name] }
  }

  named_scope :sort_by_opponent_name, :order => "players.full_name"

  def self.find_or_create player_id, opponent_id
    find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
  end

  # To make it compatible with OnlinePairStat
  def gaming_platform_id
    nil
  end
end
