class GameSource < ActiveRecord::Base
  belongs_to :game
  has_many :upload
  
  UPLOAD_TYPE = 'upload'
  PASTIE_TYPE = 'pastie'
  
  def self.recent
    find(:all, :conditions => ['created_at > ?', 7.days.ago])
  end
end
