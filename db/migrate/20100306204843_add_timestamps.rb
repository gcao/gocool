class AddTimestamps < ActiveRecord::Migration
  def self.up
    add_column :game_comments, :created_at, :datetime
    add_column :game_comments, :updated_at, :datetime
    add_column :game_details, :created_at, :datetime
    add_column :game_details, :updated_at, :datetime
    add_column :game_moves, :created_at, :datetime
    add_column :game_moves, :updated_at, :datetime
    add_column :problems, :created_at, :datetime
    add_column :problems, :updated_at, :datetime
  end

  def self.down
  end
end
