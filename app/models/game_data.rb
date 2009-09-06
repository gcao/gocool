class GameData < ActiveRecord::Base
  set_table_name :game_data
  
  belongs_to :game
  belongs_to :upload
  
  SOURCE_UPLOAD = 'upload'
end
