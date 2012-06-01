class CreateGameComments < ActiveRecord::Migration
  def up
    create_table :cg_game_comments do |t|
      t.integer :game_id
      t.integer :move_no
      t.integer :commenter_id
      t.boolean :by_player
      t.string :content, :limit => 4000
      t.timestamps
    end
  end

  def down
  end
end
