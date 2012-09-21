require 'elo'

# https://github.com/iain/elo
Elo.configure do |config|
  # Every player starts with a rating of 2000
  config.default_rating = 2000

  # A player is considered a pro, when he/she has more than 3000 points
  config.pro_rating_boundry = 3000

  # A player is considered a new, when he/she has played less than 10 games
  config.starter_boundry = 10
end

