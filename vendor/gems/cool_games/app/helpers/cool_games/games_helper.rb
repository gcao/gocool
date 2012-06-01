module CoolGames
  module GamesHelper
    def my_channels
      if @game.current_user_is_black?
        %W[game_#{@game.id}_black]
      elsif @game.current_user_is_white?
        %W[game_#{@game.id}_white]
      else
        %W[game_#{@game.id}]
      end
    end

    def to_channels
      if @game.current_user_is_black?
        %W[game_#{@game.id} game_#{@game.id}_white]
      elsif @game.current_user_is_white?
        %W[game_#{@game.id} game_#{@game.id}_black]
      end
    end

    def container_css_classes
      @game.game_type == Game::DAOQI ? "game_container daoqi" : "game_container weiqi"
    end
  end
end
