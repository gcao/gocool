class CreateUploads < ActiveRecord::Migration
  def up
    create_table :cg_uploads do |t|
      t.integer     :game_id
      t.string      :format # sgf
      t.string      :charset
      t.string      :source_type # data, path, url, upload
      t.string      :source
      t.text        :data
      t.references  :upload
      t.boolean     :is_commented
      t.string      :commented_by
      t.text        :description
      t.string      :hash_code
      t.string      :updated_by
      t.string      :file_file_name
      t.string      :file_content_type
      t.integer     :file_file_size
      t.datetime    :file_updated_at
      t.string      :status
      t.text        :status_detail
      t.string      :uploader
      t.integer     :uploader_id
      t.timestamps
    end

    add_index :cg_uploads, :game_id
    add_index :cg_uploads, :hash_code
  end

  def down
  end
end
