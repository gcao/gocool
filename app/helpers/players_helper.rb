module PlayersHelper
  def gaming_platforms_select field_name, value = nil
    platforms = GamingPlatform.all.map {|p| [p.name, p.description]}.
            # unshift(["all", t("form.select_all")]).
            push(["", t("form.select_other")])
    options = platforms.map {|p|
      if value and p[0] == value
        "<option value='#{p[0]}' selected='selected'>#{p[1]}</option>"
      else
        "<option value='#{p[0]}'>#{p[1]}</option>"
      end
    }
    select_tag field_name, options
  end
end
