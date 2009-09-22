class GameSource < ActiveRecord::Base
  belongs_to :game
  belongs_to :upload
  
  SOURCE_UPLOAD = 'upload'
end
