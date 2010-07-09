class Message < ActiveRecord::Base
  # Message Type
  REGULAR = 0
  PRIVATE = 1
  COMMENT = 2
  ADMIN   = 3
  OTHER   = 9

  # Source type
  SYSTEM = 0
  PLAYER = 1

  # Receiver type
  GAME   = 0
  PLAYER = 1

  # Level
  TRIVIAL   = 10
  INFO      = 20
  ATTENTION = 30
  IMPORTANT = 40
  
  named_scope :for_game, lambda {|game_id|
    {
      :conditions => ['receiver_id = ?', game_id]
    }
  }

  def initialize(attributes = {})
    defaults = {:message_type => REGULAR, :source_type => SYSTEM, :source => "SYSTEM", :receiver_type => GAME, :level => INFO}
    super(defaults.merge(attributes))
  end
end
