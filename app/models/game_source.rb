class GameSource < ActiveRecord::Base
  belongs_to :game
  belongs_to :upload
  
  UPLOAD_TYPE = 'upload'
  PASTIE_TYPE = 'pastie'

  default_scope :include => :game
  
  named_scope :recent, :order => 'created_at DESC'
end
