class AddPlatforms < ActiveRecord::Migration
  def self.up
    china = NationRegion.find_by_name('China')
    japan = NationRegion.find_by_name('Japan')
    GamingPlatform.create!(:nation_region_id => japan.id, :name => 'IGS',
                           :description => 'the Internet Go Server',
                           :url => 'http://www.pandanet.co.jp/English/', :is_turn_based => false)
    GamingPlatform.create!(:nation_region_id => china.id, :name => '弈城',
                           :description => '弈城围棋网',
                           :url => 'http://www.eweiqi.com', :is_turn_based => false)
    GamingPlatform.create!(:nation_region_id => china.id, :name => '新浪',
                           :description => '新浪围棋网',
                           :url => 'http://duiyi.sina.com.cn', :is_turn_based => false)
  end

  def self.down
  end
end
