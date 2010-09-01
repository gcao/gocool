class ModifyMessages < ActiveRecord::Migration
  def self.up
    rename_column :messages, :type, :message_type
  end

  def self.down
  end
end
