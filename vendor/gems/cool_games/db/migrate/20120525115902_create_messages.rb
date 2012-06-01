class CreateMessages < ActiveRecord::Migration
  def up
    create_table :cg_messages do |t|
      t.integer :source_type,   :null => false  # system, player
      t.integer :source_id
      t.string :source
      t.integer :receiver_type, :null => false # player, game
      t.integer :receiver_id
      t.string :message_type,   :null => false # private(player-player), admin, public, comment, game_state_change, other
      t.string :level      # important, attention, info, trivial
      t.string :visibility # Combination of B: black, W: white, O: observer
      t.text :content
      t.timestamps
    end

    add_index :cg_messages, [:receiver_type, :receiver_id], :name => 'messages_receiver'
  end

  def down
  end
end
