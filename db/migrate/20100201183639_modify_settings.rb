class ModifySettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :data_type, :string, :default => 'String'

    CoolGames::Setting.create!(:name => 'first_processed_post', :data_type => 'Integer', :value => '0')
    CoolGames::Setting.create!(:name => 'last_processed_post',  :data_type => 'Integer', :value => '0')
  end

  def self.down
  end
end
