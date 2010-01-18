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
    if game.primary_upload_id
      "<a target='_new#{rand(1000)}' href='#{upload_url(game.primary_upload_id)}'>#{t('form.view_button')}</a>"
    else
      '&nbsp;'
    end
  end

  def kgs_html
    "<a target='_kgs' href='http://www.gokgs.com/index.jsp?locale=zh_CN'>KGS</a>"
  end

  def gaming_platforms_select field_name, value = nil
    platforms = GamingPlatform.all.map {|p| [p.name, p.description]}.
            # unshift(["all", t("form.select_all")]).
            push(["", t("form.select_other")])
    options = platforms.map {|p|
      if (value and p[0] == value) or (value.blank? and p[0].blank?)
        "<option value='#{p[0]}' selected='selected'>#{p[1]}</option>"
      else
        "<option value='#{p[0]}'>#{p[1]}</option>"
      end
    }
    select_tag field_name, options
  end

  private

  def url_for_player id, is_online_game
    if id
      if is_online_game
        online_player_url(id)
      else
        player_url(id)
      end
    end
  end

  def player_html name, url, is_winner
    css_class = "winner" if is_winner
    html = name
    html = "<a href='#{url}'>#{html}</a>" if url
    "<td class='#{css_class}'>#{html}</td>"
  end
end
