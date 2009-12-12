# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mark_required
    "<span class='required_field'>*</span>&nbsp;"
  end
  
  def show_flash container_class
    render :partial => 'shared/show_flash', :locals => {:container_class => container_class}
  end

  def include_jquery
    if RAILS_ENV == 'production'
      '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js" type="text/javascript"></script>'
    else
      javascript_include_tag "jquery"
    end
  end
  
  def black_player_html(game)
    name      = game.black_name_with_rank
    url       = url_for_player(game.black_id, game.is_online_game?)
    is_winner = game.winner == Game::WINNER_BLACK
    player_html(name, url, is_winner)
  end
  
  def white_player_html(game)
    name      = game.white_name_with_rank
    url       = url_for_player(game.white_id, game.is_online_game?)
    is_winner = game.winner == Game::WINNER_WHITE
    player_html(name, url, is_winner)
  end

  def view_game_html(game)
    if game.primary_game_source_id
      "<a href='#{game_source_url(game.primary_game_source_id)}'>#{t('form.view_button')}</a>"
    else
      '&nbsp;'
    end
  end

  private

  def url_for_player id, is_online_game
    online_player_url(id) if id and is_online_game
  end

  def player_html name, url, is_winner
    css_class = "winner" if is_winner
    html = name
    html = "<a href='#{url}'>#{html}</a>" if url
    "<td class='#{css_class}'>#{html}</td>"
  end
end
