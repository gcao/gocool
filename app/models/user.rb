class User < ActiveRecord::Base
  DISCUZ_USER = 1
  
  validates_presence_of :username
  validates_presence_of :user_type

  def self.find_or_create attributes
    find_by_username(attributes[:username]) || create!(attributes)
  end
end
