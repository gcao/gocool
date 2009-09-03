class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.string :email, :null => false
      t.string :upload_file_name, :null => false
      t.string :upload_content_type
      t.integer :upload_file_size
      t.datetime :upload_updated_at
      t.string :status
      t.text :status_detail
      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
