class HomepageController < ApplicationController
  def index
    if logged_in?
      @invitations_to_me = Invitation.active.to_me
      @invitations_by_me = Invitation.active.by_me
      @qiren_games = Game.on_platform(GamingPlatform.qiren).with_detail.sort_by_last_move_time
      @my_uploads = Upload.recent.find_all_by_uploader_id(@current_user.id)
      @games_of_my_turn = Game.my_turn(@current_user.qiren_player).not_finished
      @games_of_not_my_turn = Game.not_my_turn(@current_user.qiren_player).not_finished
      @my_finished_games = Game.by_player(@current_user.qiren_player).finished
    else
      @qiren_games = Game.on_platform(GamingPlatform.qiren).with_detail.sort_by_last_move_time
      @uploads = Upload.recent

      @games_total = Game.count
      @games_of_seven_days = Upload.recent_7_days.count
      @games_of_today = Upload.today.count
      @games_of_qiren = Game.gaming_platform_id_is(GamingPlatform.qiren.id).count
      @games_of_kgs = Game.gaming_platform_id_is(GamingPlatform.kgs.id).count
      @games_of_tom = Game.gaming_platform_id_is(GamingPlatform.tom.id).count
      @games_of_dgs = Game.gaming_platform_id_is(GamingPlatform.dgs.id).count
    end
  end
end
