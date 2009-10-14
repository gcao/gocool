class OnlinePlayer < ActiveRecord::Base
  belongs_to :player
  belongs_to :gaming_platform
  
  named_scope :on_platform, lambda {|platform| {:conditions => ["gaming_platform_id = ?", platform.id]} }
  named_scope :username_like, lambda {|username| {:conditions => ["username like '%?%", username]} }
  
  def self.find_or_create platform, username
    on_platform(platform).find_by_username(username) || create!(:gaming_platform_id => platform.id, :username => username)
  end
  
  def self.search platform_name, username, page_no = 0
    k = self
    k = k.on_platform(GamingPlatform.find_by_name(platform_name)) unless platform_name.blank?
    k = k.username_like(username) unless username.blank?
    k.all
  end
end
