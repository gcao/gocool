# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mark_required
    "<span class='required_field'>*</span>&nbsp;"
  end
  
  def show_flash container_class
    render :partial => 'shared/show_flash', :locals => {:container_class => container_class}
  end
  
  def black_player_html(game)
    css_class = "winner" if game.winner == Game::WINNER_BLACK
    "<td class='#{css_class}'>#{game.black_name_with_rank}</td>"
  end
  
  def white_player_html(game)
    css_class = "winner" if game.winner == Game::WINNER_WHITE
    "<td class='#{css_class}'>#{game.white_name_with_rank}</td>"
  end
end
