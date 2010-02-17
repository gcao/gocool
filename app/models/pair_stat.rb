class PairStat < ActiveRecord::Base
  include AbstractPlayerStat
  
  belongs_to :player, :class_name => "Player", :foreign_key => :player_id
  belongs_to :opponent, :class_name => "Player", :foreign_key => :opponent_id

  default_scope :include => 'opponent', :conditions => ["pair_stats.games_as_black > 0 or pair_stats.games_as_white > 0"]

  named_scope :opponent_name_like, lambda{ |name|
    { :conditions => ["players.name like ?", name] }
  }

  named_scope :sort_by_opponent_name, :order => "players.name"

  def self.find_or_create player_id, opponent_id
    find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
  end
end
