class CreateGameComments < ActiveRecord::Migration
  def self.up
    create_table :game_comments do |t|
      t.integer :game_id
      t.integer :move_no
      t.integer :commenter_id
      t.boolean :by_player
      t.string :content, :limit => 4000
    end
  end

  def self.down
  end
end
