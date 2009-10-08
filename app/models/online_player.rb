class OnlinePlayer < ActiveRecord::Base
  belongs_to :gaming_platform
  
  named_scope :on_platform, lambda {|platform| {:conditions => ["gaming_platform_id = ?", platform.id]} }
  
  def self.find_or_create platform, username
    on_platform(platform).find_by_username(username) || create!(:gaming_platform_id => platform.id, :username => username)
  end
end
