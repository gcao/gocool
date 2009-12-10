class Internal::TestController < ApplicationController
  before_filter :login_check

  def index
    render 'uploads/index'
  end
end
