class ModifyUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :file_file_name, :string
    add_column :uploads, :file_content_type, :string
    add_column :uploads, :file_file_size, :integer
    add_column :uploads, :file_updated_at, :datetime
    add_column :uploads, :status, :string
    add_column :uploads, :status_detail, :text
    add_column :uploads, :uploader, :string
    add_column :uploads, :uploader_id, :integer
  end

  def self.down
  end
end
