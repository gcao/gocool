class Internal::TestController < ApplicationController
  layout nil
  layout 'application_integrated'

  def index
    render 'uploads/index'
  end
end
