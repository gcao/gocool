module CoolGames
  class PairStat < ActiveRecord::Base
    include AbstractPlayerStat

    set_table_name "cg_pair_stats"

    belongs_to :player, :class_name => "Player", :foreign_key => :player_id
    belongs_to :opponent, :class_name => "Player", :foreign_key => :opponent_id

    default_scope :include => 'opponent'

    scope :opponent_name_like, lambda{ |name|
      { :conditions => ["name like ?", name] }
    }

    scope :sort_by_opponent_name, joins(:opponent).order(:name)

    def self.find_or_create player_id, opponent_id
      find_by_player_id_and_opponent_id(player_id, opponent_id) || create!(:player_id => player_id, :opponent_id => opponent_id)
    end
  end
end
