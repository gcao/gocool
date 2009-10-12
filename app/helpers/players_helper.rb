module PlayersHelper
  def gaming_platforms_select form, field_name
    platforms = GamingPlatform.all.map {|p| [p.name, p.description]}
    form.select field_name, platforms
  end
end