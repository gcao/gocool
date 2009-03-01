class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.integer :parent_id
      t.boolean :is_series, :is_primary
      t.string :name
      t.string :organizer
      t.text :description
      t.string :stage
      t.boolean :has_sub_tournaments
      t.date :start_date, :end_date
      t.integer :lft, :rgt
      t.string :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :tournaments
  end
end
