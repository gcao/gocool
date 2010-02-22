class ModifyUsers3 < ActiveRecord::Migration
  def self.up
    add_column :users, :qiren_player_id, :integer
    
    add_index :users, :qiren_player_id, :name => 'users_qiren_player_id'
  end

  def self.down
  end
end
