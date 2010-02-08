class HomepageController < ApplicationController
  def index
    @uploads = Upload.recent

    @games_total = Game.count
    @games_of_seven_days = Upload.recent_7_days.count
    @games_of_today = Upload.today.count
    @games_of_kgs = Game.gaming_platform_id_is(GamingPlatform.kgs.id).count
    @games_of_tom = Game.gaming_platform_id_is(GamingPlatform.tom.id).count
    @games_of_dgs = Game.gaming_platform_id_is(GamingPlatform.dgs.id).count

    if logged_in?
      @my_uploads = Upload.recent.find_all_by_uploader_id(@user.id)
    end
  end
end
