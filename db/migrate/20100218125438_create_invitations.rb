class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :invitees, :limit => 1024 # In JSON format, like {"1":"test"}
      t.integer :game_type
      t.string :state
      t.integer :rule # 1 - Chinese, 2 - Japanese, 3 - Korean, 4 - Ying
      t.integer :handicap
      t.integer :start_side # 1 - inviter, 2 - invitee
      t.float :komi
      t.boolean :for_rating
      t.string :note
      t.string :response, :limit => 4000
      t.date :expires_on
      t.integer :game_id
      t.timestamps
    end

    add_index :invitations, :inviter_id, :name => 'invitations_inviter_id'
    add_index :invitations, :invitees,   :name => 'invitations_invitees'
  end

  def self.down
  end
end
