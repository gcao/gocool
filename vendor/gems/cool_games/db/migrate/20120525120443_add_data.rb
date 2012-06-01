# coding: utf-8
class AddData < ActiveRecord::Migration
  def up
    china = CoolGames::NationRegion.create!(:name => 'China')
    usa   = CoolGames::NationRegion.create!(:name => 'USA')
    japan = CoolGames::NationRegion.create!(:name => 'Japan')
    korea = CoolGames::NationRegion.create!(:name => 'Korea')

    CoolGames::GamingPlatform.create!(:nation_region_id => usa.id, :name => 'KGS',
                           :description => 'The KGS Go Server', :url => 'www.gokgs.com')
    CoolGames::GamingPlatform.create!(:nation_region_id => usa.id, :name => 'DGS',
                           :description => 'The Dragon Go Server',
                           :url => 'www.dragongoserver.net', :is_turn_based => true)
    CoolGames::GamingPlatform.create!(:nation_region_id => china.id, :name => 'TOM',
                           :description => 'TOM围棋网',
                           :url => 'weiqi.sports.tom.com', :is_turn_based => false)
    CoolGames::GamingPlatform.create!(:nation_region_id => japan.id, :name => 'IGS',
                           :description => 'The Internet Go Server',
                           :url => 'http://www.pandanet.co.jp/English/', :is_turn_based => false)
    CoolGames::GamingPlatform.create!(:nation_region_id => china.id, :name => 'eWeiqi',
                           :description => '弈城围棋网',
                           :url => 'http://www.eweiqi.com', :is_turn_based => false)
    CoolGames::GamingPlatform.create!(:nation_region_id => china.id, :name => 'Sina',
                           :description => '新浪围棋网',
                           :url => 'http://duiyi.sina.com.cn', :is_turn_based => false)
    CoolGames::GamingPlatform.create!(:nation_region_id => usa.id, :name => 'Gocool',
                           :description => '棋人',
                           :url => 'http://duiyi.sina.com.cn', :is_turn_based => false)
  end

  def down
  end
end
