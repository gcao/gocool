# This class contains miscellaneous admin operations, e.g. reload games from url
# Each operation might require two actions: one for entering parameters, another for processing and display result
#
# These actions should only be accessible when logged in as admin or from localhost.
class Admin::MiscController < ApplicationController
  def index
  end
  
  # Update won/lost statistics
  def update_stat
    redirect_to :action => :index
  end
  
  def broadcast_game
    redirect_to "/bbs/index.php"
  end
end
