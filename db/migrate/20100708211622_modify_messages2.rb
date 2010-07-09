class ModifyMessages2 < ActiveRecord::Migration
  def self.up
    add_column :messages, :source, :string
    add_column :messages, :created_at, :datetime
    add_column :messages, :updated_at, :datetime
  end

  def self.down
  end
end
