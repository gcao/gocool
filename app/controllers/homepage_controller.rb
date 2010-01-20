class HomepageController < ApplicationController
  def index
    @my_uploads = Upload.recent.find_all_by_uploader_id(@user.id).paginate(page_params)

    @uploads = Upload.recent.paginate(page_params)

    @games_total = Game.count
    @games_of_seven_days = Upload.recent_7_days.count
    @games_of_today = Upload.today.count
    @games_of_kgs = Game.kgs.count
  end
end
