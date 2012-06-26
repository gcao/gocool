class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable,
         :authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :login, :password, :password_confirmation, :remember_me, :confirmed_at
  attr_accessor :login

  has_one :player, :class_name => 'CoolGames::Player', :dependent => :destroy, :foreign_key => 'parent_id'

  after_create :create_player

  def create_player
    CoolGames::Player.create!(:gaming_platform => CoolGames::GamingPlatform.gocool,
                              :parent_id => id,
                              :email => email,
                              :name => username)
  end

  #this method is for letting users authenticate both with emails and usernames
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
