class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :confirmed_at

  has_one :player, :class_name => 'CoolGames::Player', :dependent => :destroy, :foreign_key => 'parent_id'

  after_create :create_player

  def create_player
    CoolGames::Player.create!(:gaming_platform => CoolGames::GamingPlatform.gocool, :parent_id => id, :email => email, :name => email)
  end
end
