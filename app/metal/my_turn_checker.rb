# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class MyTurnChecker
  def self.call(env)
    if env["PATH_INFO"] =~ %r(/games/my_turn$)
      request = Rack::Request.new(env)

      if Game.my_turn_by_name(request.params['player']).not_finished.count > 0
        response = "my_turn"
      elsif Game.by_name(request.params['player']).not_finished.count > 0
        response = "not_my_turn"
      else
        response = "no_game"
      end
      [200, {"Content-Type" => "text/html"}, [response]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  ensure
    # Release the connections back to the pool.
    ActiveRecord::Base.clear_active_connections!
  end
end
