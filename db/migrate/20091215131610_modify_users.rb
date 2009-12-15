class ModifyUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :integer, :default => 0 # 1: discuz forum user
    add_column :users, :external_id, :integer
    add_column :users, :role, :integer, :default => 0 # 1: admin, 0: regular
  end

  def self.down
  end
end
