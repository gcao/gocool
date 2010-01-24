class HomepageController < ApplicationController
  def index
    @uploads = Upload.recent

    @games_total = Game.count
    @games_of_seven_days = Upload.recent_7_days.count
    @games_of_today = Upload.today.count
    @games_of_kgs = Game.kgs.count

    if logged_in?
      @my_uploads = Upload.recent.find_all_by_uploader_id(@user.id)
    end
  end
end
