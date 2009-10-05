class GamingPlatform < ActiveRecord::Base
  def self.kgs
    @kgs ||= self.find_by_name('KGS')
  end
end
