class Admin::BaseController < ApplicationController
#  layout 'admin'

  before_filter lambda{ raise 'NOT ENABLED' if RAILS_ENV != 'development' }
end
