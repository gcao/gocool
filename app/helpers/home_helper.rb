module HomeHelper
  def black_player_html(game)
    css_class = "winner" if game.winner == Game::WINNER_BLACK
    "<td class='#{css_class}'>#{game.black_name_with_rank}</td>"
  end
  
  def white_player_html(game)
    css_class = "winner" if game.winner == Game::WINNER_WHITE
    "<td class='#{css_class}'>#{game.white_name_with_rank}</td>"
  end
end