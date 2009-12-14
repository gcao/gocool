class ModifyGameSources < ActiveRecord::Migration
  def self.up
    add_column :game_sources, :upload_file_name, :string, :null => false
    add_column :game_sources, :upload_content_type, :string
    add_column :game_sources, :upload_file_size, :integer
    add_column :game_sources, :upload_updated_at, :datetime
    add_column :game_sources, :status, :string
    add_column :game_sources, :status_detail, :text
    add_column :game_sources, :hash_code, :string
    add_column :game_sources, :uploader, :string
    add_column :game_sources, :uploader_id, :integer
  end

  def self.down
  end
end
