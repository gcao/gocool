module CoolGames
  class RatingInfo
    include Mongoid::Document
    include Mongoid::Timestamps

    DEFAULT_RATING = 2150
    GAMES_FOR_STAR = 10

    has_one     :game  , class_name: 'CoolGames::Game'
    embedded_in :player, class_name: 'CoolGames::Player'

    def self.compute_rank rating
      if rating < 0
        "30K"
      elsif rating < 1000
      elsif rating < 2000
      elsif rating < 3000
      else
        "9D"
      end
    end

    field "rating"     , type: Integer, default: DEFAULT_RATING
    field "old_rating" , type: Integer, default: DEFAULT_RATING
    field "rank"       , type: String , default: compute_rank(DEFAULT_RATING)
    field "rated_games", type: Integer, default: 0

    def update_rank
      self.rank = self.class.compute_rank rating
      self.rank += "*" if rated_games >= GAMES_FOR_STAR
      self.rank
    end

    def self.rate_game game
      return unless game.for_rating
      return unless game.black_player and game.white_player
      return unless [Game::BLACK, Game::WHITE].include? game.winner
      
      black_player = game.black_player
      white_player = game.white_player

      b = Elo::Player.new black_player.rating
      w = Elo::Player.new white_player.rating

      if game.winner == Game::BLACK
        b.wins_from(w)
      else
        b.loses_from(w)
      end

      black_rating_info             = RatingInfo.new
      black_rating_info.rating      = b.rating
      black_rating_info.game        = game
      black_rating_info.old_rating  = black_player.rating
      black_rating_info.rated_games = black_player.rated_games + 1
      black_rating_info.update_rank

      black_player.rating_info      = black_rating_info
      black_player.rating_history.unshift black_rating_info

      white_rating_info             = RatingInfo.new
      white_rating_info.rating      = w.rating
      white_rating_info.game        = game
      white_rating_info.old_rating  = white_player.rating
      white_rating_info.rated_games = white_player.rated_games + 1
      white_rating_info.update_rank

      white_player.rating_info      = white_rating_info
      white_player.rating_history.unshift white_rating_info
    end

  end
end

