class GameMove < ActiveRecord::Base
  belongs_to :game_detail
  acts_as_nested_set
end
