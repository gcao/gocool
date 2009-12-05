class LoginController < ApplicationController
  def unauthenticated
    render :text => 'NOT LOGGED IN'
  end
end
