class GamingPlatform < ActiveRecord::Base
  default_scope :order => 'name'
  
  def self.kgs
    @kgs ||= self.find_by_name('KGS')
  end
end
