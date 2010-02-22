class User < ActiveRecord::Base
  # User types
  DISCUZ_USER = 1

  # Roles
  ADMIN = 1

  belongs_to :qiren_player, :class_name => 'Player', :foreign_key => 'qiren_player_id'
  
  validates_presence_of :username
  validates_presence_of :user_type

  def self.find_or_create attributes
    find_by_username(attributes[:username]) || create!(attributes)
  end

  def self.find_or_load username
    user = find_by_username(username)
    return user if user 

    discuz_member = Discuz::Member.find_by_username(username)
    raise ActiveRecord::RecordNotFound.new("#{username} is not found") unless discuz_member

    create!(:username => username, :external_id => discuz_member.id, :email => discuz_member.email)
  end

  def email
    if attributes[:email].blank?
      if discuz_member = Discuz::Member.find_by_username(username)
        self.email = discuz_member.email
        save!
      end
    end
    super
  end

  def qiren_player
    if qiren_player_id.blank?
      Player.create!(:gaming_platform_id => GamingPlatform.qiren.id, :username => username, :email => email)
    end
    super
  end

  def admin?
    role == ADMIN
  end
end
