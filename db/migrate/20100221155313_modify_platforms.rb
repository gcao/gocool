# coding: utf-8
class ModifyPlatforms < ActiveRecord::Migration
  def self.up
    add_column :gaming_platforms, :sort_order, :integer

    CoolGames::GamingPlatform.create!(:nation_region_id => CoolGames::NationRegion.find_by_name('China').id, :name => '棋人',
                           :description => '棋人非即时对弈网', :url => 'http://www.go-cool.org/app')
  end

  def self.down
  end
end
