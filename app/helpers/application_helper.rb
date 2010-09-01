# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mark_required
    "<span class='required_field'>*</span>&nbsp;"
  end
  
  def show_flash container_class
    render :partial => 'shared/show_flash', :locals => {:container_class => container_class}
  end

  def include_jquery
    if Rails.env.production?
      '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js" type="text/javascript"></script>'
    else
      javascript_include_tag "jquery"
    end
  end
  
  def black_player_html(game)
    name      = game.black_name_with_rank
    is_winner = game.winner == Game::WINNER_BLACK
    url       = player_url(game.black_id) if game.black_id
    player_html(name, url, is_winner)
  end
  
  def white_player_html(game)
    name      = game.white_name_with_rank
    is_winner = game.winner == Game::WINNER_WHITE
    url       = player_url(game.white_id) if game.white_id
    player_html(name, url, is_winner)
  end

  def upload_description_html upload
    if upload.nil?
      ""
    elsif upload.discuz_tid.not_blank? and upload.description.not_nil?
      "<a href='#{upload.discuz_thread_url}' target='_new'>#{h(upload.description)}</a>"
    else
      h upload.description
    end
  end

  def view_game_html(game)
    url = game.primary_upload_id ? upload_url(game.primary_upload_id) : game_url(game)
    "<a target='_new#{rand(1000)}' href='#{url}'>#{t('form.view_button')}</a>"
  end

  def gaming_platforms_select field_name, value = nil
    platforms = GamingPlatform.all.map {|p| [p.id, p.description]}.
            push(["", t("form.select_other")]).unshift([GamingPlatform::ALL.to_s, ""])
    options = platforms.map {|p|
      if value and p[0] == value
        "<option value='#{p[0]}' selected='selected'>#{p[1]}</option>"
      else
        "<option value='#{p[0]}'>#{p[1]}</option>"
      end
    }
    select_tag field_name, options
  end

  def reset_button
    "<input type='button' name='reset', value='#{t('form.reset_button')}'/>"
  end
  
  def platform_link platform, with_bracket = true
    return unless platform
    
    # s = "<a href='#{platform_url(platform)}'>#{platform.name}</a>"
    s = platform.name
    
    if with_bracket
      "[#{s}]"
    else
      s
    end
  end

  private

  def player_html name, url, is_winner
    css_class = "winner" if is_winner
    html = h(name)
    html = "<a href='#{url}'>#{html}</a>" if url
    "<td class='#{css_class}'>#{html}</td>"
  end
end
