# coding: utf-8
class AddPlatforms < ActiveRecord::Migration
  def self.up
    china = CoolGames::NationRegion.find_by_name('China')
    japan = CoolGames::NationRegion.find_by_name('Japan')
    CoolGames::GamingPlatform.create!(:nation_region_id => japan.id, :name => 'IGS',
                           :description => 'the Internet Go Server',
                           :url => 'http://www.pandanet.co.jp/English/', :is_turn_based => false)
    CoolGames::GamingPlatform.create!(:nation_region_id => china.id, :name => '弈城',
                           :description => '弈城围棋网',
                           :url => 'http://www.eweiqi.com', :is_turn_based => false)
    CoolGames::GamingPlatform.create!(:nation_region_id => china.id, :name => '新浪',
                           :description => '新浪围棋网',
                           :url => 'http://duiyi.sina.com.cn', :is_turn_based => false)
  end

  def self.down
  end
end
