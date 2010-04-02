class CreateMessages < ActiveRecord::Migration
  def self.up
    # Integrate with and avoid confusion between discuz forum private messages
    create_table :messages do |t|
      t.integer :source_type, :null => false  # system, black, white, admin
      t.integer :source_id
      t.integer :receiver_type, :null => false # player, game
      t.integer :receiver_id
      t.string :type, :null => false # private(player-player), public, comment, game_state_change, trivial(B is online...)  
      t.string :level # trivial, info, attention, response_required (similar to log level) ?!
      t.string :visibility # Combination of B: black, W: white, O: observer
      t.string :content, :limit => 65000
    end

    add_index :messages, [:receiver_type, :receiver_id], :name => 'messages_receiver'
  end

  def self.down
  end
end
