module PlayersHelper
  def gaming_platforms_select field_name
    platforms = GamingPlatform.all.map {|p| [p.name, p.description]}.unshift(["", t("form.select_all")])
    options = platforms.map {|p| "<option value='#{p[0]}'>#{p[1]}</option>" }
    select_tag field_name, options
  end
end