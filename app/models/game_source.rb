class GameSource < ActiveRecord::Base
  belongs_to :game
  belongs_to :upload
  
  UPLOAD_TYPE = 'upload'
  PASTIE_TYPE = 'pastie'
end
