class Admin::BaseController < ApplicationController
  before_filter :set_admin_flag

  def set_admin_flag
    @admin_page = true
  end
end
