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
    controller.send :helper_method, :current_user, :logged_in?
    controller.filter_parameter_logging :password
  end
  
  def current_user
    request.env['warden'].user
  end
  
  def logged_in?
    current_user.nil?
  end
  
  def login_required
    request.env['warden'].authenticate!
    unless logged_in?
      throw :warden
    end
  end
end
