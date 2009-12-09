# TOREMOVE?
# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
# 
#   <% if logged_in? %>
#     Welcome <%= current_user.username %>! Not you?
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
# 
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
# 
#   before_filter :login_required, :except => [:index, :show]
module Authentication
  def self.included(controller)
    controller.send :helper_method, :login_session, :logged_in?
    controller.filter_parameter_logging :password
  end
  
  def login_session
    request.env['forum_session']
  end
  
  def logged_in?
    not login_session.nil?
  end

  def login_check
    request.env['forum_session'] = nil
    return unless ENV['INTEGRATE_WITH_FORUM']

    username  = request.cookies[ENV['DISCUZ_COOKIE_USERNAME']]
    auth      = request.cookies[ENV['DISCUZ_COOKIE_AUTH']]

    return if auth.blank? or username.blank?

    request.env['forum_session'] = Discuz::Session.find_by_username username
  end
  
  def login_required
    redirect_to login_url unless login_check
  end
end
