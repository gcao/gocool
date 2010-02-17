module Admin::GamesHelper
  def winner_form_column record, input_name
    select :record, :winner, [[t('games_widget.winner_black'), Game::WINNER_BLACK], [t('games_widget.winner_white'), Game::WINNER_WHITE]], { :include_blank => true }
  end
#  def black_id_form_column record, input_name
#  end
end
