Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :my_strategy
  manager.failure_app = LoginController

  manager.default_serializers :session, :cookie
  manager.serializers.update(:session) do
    def serialize(user)
      user
    end

    def deserialize(id)
      id
    end
  end
end

# Declare your strategies here
Warden::Strategies.add(:my_strategy) do
  def authenticate!
    env['warden'].set_user nil
    return unless ENV['INTEGRATE_WITH_FORUM']

    username  = request.cookies[ENV['DISCUZ_COOKIE_USERNAME']]
    auth      = request.cookies[ENV['DISCUZ_COOKIE_AUTH']]

    return if auth.blank? or username.blank?
    
    session = Discuz::Session.find_by_username username
    if session
      env['warden'].set_user session
    end
  end
end
