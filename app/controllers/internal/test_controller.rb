class Internal::TestController < ApplicationController
  layout nil
  layout 'application_integrated'

  before_filter :login_check

  def index
    render 'uploads/index'
  end
end
