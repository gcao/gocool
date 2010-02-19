class User < ActiveRecord::Base
  DISCUZ_USER = 1
  ADMIN = 1
  
  validates_presence_of :username
  validates_presence_of :user_type

  def self.find_or_create attributes
    find_by_username(attributes[:username]) || create!(attributes)
  end

  def self.find_or_load username
    return user if user = find_by_username(username)

    discuz_member = Discuz::Member.find_by_username(username)
    raise ActiveRecord::RecordNotFound.new("#{username} is not found") unless discuz_member

    create!(:username => username, :external_id => discuz_member.id)
  end

  def admin?
    user_type == ADMIN
  end
end
