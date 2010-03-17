class ModifyGameDetails < ActiveRecord::Migration
  def self.up
    remove_column :game_details, :handicaps

    add_column :game_moves, :setup_points, :string
    remove_column :game_moves, :lft
    remove_column :game_moves, :rgt
  end

  def self.down
  end
end
