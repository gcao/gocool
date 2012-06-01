class CreateInvitations < ActiveRecord::Migration
  def up
    create_table :cg_invitations do |t|
      t.integer :inviter_id
      t.string :invitees, :limit => 1024 # In JSON format, like {"1":"test"}
      t.integer :game_type
      t.string :state
      t.integer :rule, :default => 1 # 1 - Chinese, 2 - Japanese, 3 - Korean, 4 - Ying
      t.integer :handicap, :default => 0
      t.integer :start_side # 1 - inviter, 2 - invitee
      t.float :komi, :default => 7.5
      t.boolean :for_rating, :default => true
      t.string :note
      t.string :response, :limit => 4000
      t.date :expires_on
      t.integer :game_id
      t.timestamps
    end

    add_index :cg_invitations, :inviter_id, :name => 'invitations_inviter_id'
    add_index :cg_invitations, :invitees,   :name => 'invitations_invitees'
  end

  def down
  end
end
