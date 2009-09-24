class GameSource < ActiveRecord::Base
  belongs_to :game
  has_many :upload
  
  UPLOAD_TYPE = 'upload'
  PASTIE_TYPE = 'pastie'
end
