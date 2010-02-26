class Admin::BaseController < ApplicationController
  #layout 'admin'

  #before_filter lambda{ raise 'NOT ENABLED' if RAILS_ENV != 'development' }
  before_filter :set_admin_flag

  def set_admin_flag
    @admin_page = true
  end
end
