Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :my_strategy
  manager.failure_app = LoginController
end

class Warden::Serializers::Session
  def serialize user
    user
  end

  def deseriaze klass, id
    id
  end
end

# Declare your strategies here
Warden::Strategies.add(:my_strategy) do
  def authenticate!
    return unless ENV['INTEGRATE_WITH_FORUM']

    session_id = request.cookies[ENV['SESSION_ID_KEY']]
    session = Discuz::Session.find(session_id)
    unless session.username.blank?
      success!(session)
    end
  end
end
