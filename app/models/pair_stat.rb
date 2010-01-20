class PairStat < ActiveRecord::Base
  include AbstractPlayerStat, AbstractPairStat
  
  belongs_to :opponent, :class_name => "Player", :foreign_key => :opponent_id

  default_scope :include => 'opponent'
end
