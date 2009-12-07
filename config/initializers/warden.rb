Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :my_strategy
  manager.failure_app = LoginController
end

# Setup Session Serialization
Warden::Manager.serialize_into_session{ |user| user }
Warden::Manager.serialize_from_session{ |klass, id| id }

# Declare your strategies here
Warden::Strategies.add(:my_strategy) do
  def authenticate!
    logger.info '************* authenticate! ***************'
    return unless ENV['INTEGRATE_WITH_FORUM']

    session_id = request.cookie[ENV['SESSION_ID_KEY']]
    session = Discuz::Session.find(session_id)
    unless session.username.blank?
      success!(session)
    end
  end
end
