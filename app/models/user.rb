class User
  include Mongoid::Document
  include Mongoid::Timestamps

	rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable,
         :authentication_keys => [:login]

  ## Database authenticatable
  field :email,              :type => String
  field :username,           :type => String
  field :encrypted_password, :type => String

  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Token authenticatable
  field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :login, :password, :password_confirmation, :remember_me, :confirmed_at
  attr_accessor :login

  has_one :player, :class_name => 'CoolGames::Player', inverse_of: :user

  after_create do
    self.player = CoolGames::Player.create!(:gaming_platform => CoolGames::GamingPlatform.gocool,
                                            :user            => self,
                                            :email           => email,
                                            :name            => username)
    self.save!
  end

  #this method is for letting users authenticate both with emails and usernames
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup

    if login = conditions.delete(:login)
      login.downcase!

      where(conditions).any_of({username: login},  {email: login}).first
    else
      where(conditions).first
    end
  end
end
