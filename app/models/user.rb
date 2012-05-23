class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :confirmed_at

  has_one :player, :class_name => 'Player', :dependent => :destroy, :foreign_key => 'parent_id'

  after_create :create_player

  def create_player
    Player.create!(:gaming_platform => GamingPlatform.gocool, :parent_id => id, :email => email, :name => email)
  end
end
