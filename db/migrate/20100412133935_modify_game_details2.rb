class ModifyGameDetails2 < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "alter table game_details modify formatted_moves text"
  end

  def self.down
  end
end
