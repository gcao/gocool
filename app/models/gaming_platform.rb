class GamingPlatform < ActiveRecord::Base
  default_scope :order => 'name'
  
  def self.kgs
    @kgs ||= self.find_by_name('KGS')
  end

  def self.dgs
    @dgs ||= self.find_by_name('DGS')
  end

  def self.tom
    @tom ||= self.find_by_name('TOM')
  end
end
