class DropUploads < ActiveRecord::Migration
  def self.up
    drop_table :uploads
  end

  def self.down
  end
end
