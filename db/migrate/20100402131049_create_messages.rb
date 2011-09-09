class CreateMessages < ActiveRecord::Migration
  def self.up
    # Integrate with and avoid confusion between discuz forum private messages
    create_table :messages do |t|
      t.integer :source_type,   :null => false  # system, player
      t.integer :source_id
      t.integer :receiver_type, :null => false # player, game
      t.integer :receiver_id
      t.string :type,           :null => false # private(player-player), admin, public, comment, game_state_change, other
      t.string :level      # important, attention, info, trivial
      t.string :visibility # Combination of B: black, W: white, O: observer
      t.text :content
    end

    add_index :messages, [:receiver_type, :receiver_id], :name => 'messages_receiver'
  end

  def self.down
  end
end
