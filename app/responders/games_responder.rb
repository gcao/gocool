class GamesResponder < BaseResponder
  def initialize games
    super "games.html"
    @games = games
  end
end
