class OnlinePairStat < ActiveRecord::Base
  include AbstractPlayerStat, AbstractPairStat

  belongs_to :opponent, :class_name => "OnlinePlayer", :foreign_key => :opponent_id

  default_scope :include => 'opponent'
end
