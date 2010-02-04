class NationsAndPlatforms < ActiveRecord::Migration
  def self.up
    china = NationRegion.create!(:name => 'China')
    usa   = NationRegion.create!(:name => 'USA')
    japan = NationRegion.create!(:name => 'Japan')
    korea = NationRegion.create!(:name => 'Korea')

    GamingPlatform.create!(:nation_region_id => usa.id, :name => 'KGS',
                           :description => 'The KGS Go Server', :url => 'www.gokgs.com')
    GamingPlatform.create!(:nation_region_id => usa.id, :name => 'DGS',
                           :description => 'The Dragon Go Server',
                           :url => 'www.dragongoserver.net', :is_turn_based => true)
    GamingPlatform.create!(:nation_region_id => china.id, :name => 'TOM',
                           :description => 'TOM???',
                           :url => 'weiqi.sports.tom.com', :is_turn_based => false)
  end

  def self.down
    ActiveRecord::Base.connection.execute("delete from gaming_platforms")
    ActiveRecord::Base.connection.execute("delete from nation_regions")
  end
end
