class GamesResponder < ApplicationResponder
  include GamesHelper
  
  def initialize games
    super(nil)
    @games = games
    @children[:title] = "Games"
    @children[:body] = render_template("games.html")
    @children[:footer] = render_template("games_footer.html")
  end
end
