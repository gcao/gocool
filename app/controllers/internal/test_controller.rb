class Internal::TestController < ApplicationController
  layout nil
  layout 'application_integrated'

  before_filter :login_required

  def index
    render 'uploads/index'
  end
end
