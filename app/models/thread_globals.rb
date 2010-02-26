module ThreadGlobals
  def logged_in?
    not current_user.nil?
  end

  def current_user
    Thread.current[:user]
  end

  def current_player
    current_user.nil? ? nil : current_user.qiren_player
  end
end
