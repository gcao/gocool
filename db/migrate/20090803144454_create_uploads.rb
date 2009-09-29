class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.string    :upload_file_name, :null => false
      t.string    :upload_content_type
      t.integer   :upload_file_size
      t.datetime  :upload_updated_at
      t.string    :status
      t.text      :status_detail
      t.string    :email
      t.string    :hash_code
      t.timestamps
    end

    add_index :uploads, :hash_code
  end

  def self.down
    drop_table :uploads
  end
end
