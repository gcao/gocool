class ModifyUsers2 < ActiveRecord::Migration
  def self.up
    add_index :users, [:username]
    add_index :users, [:user_type, :external_id]
  end

  def self.down
  end
end
