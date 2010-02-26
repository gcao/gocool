class ModifyUsers3 < ActiveRecord::Migration
  def self.up
    add_column :users, :qiren_player_id, :integer
    add_column :players, :open_for_invitation, :boolean

    add_index :users, :qiren_player_id, :name => 'users_qiren_player_id'

    user_count = User.count
    1.upto(user_count/50 + 1) do |page|
      User.paginate(:per_page => 50, :page => page ).each do |user|
        result = Discuz::Base.connection.execute("select email from discuz_members where uid=#{user.external_id}")
        email = result.fetch_row.first
        result.free

        user.email = email
        user.qiren_player = Player.create!(:gaming_platform_id => GamingPlatform.qiren.id, :name => user.username, :email => email)
        user.save!
      end
    end
  end

  def self.down
  end
end
