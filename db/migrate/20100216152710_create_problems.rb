class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.string :name
      t.string :level
      t.integer :start_color
      t.string :result
      t.boolean :multiple
      t.text :description
      t.string :source
      t.integer :upload_id, :solution_upload_id
    end
  end

  def self.down
    drop_table :problems
  end
end
