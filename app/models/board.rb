class Board < Array
  def initialize size, game_type = Game::WEIQI
    @size = size
    @game_type = game_type
    reset
  end

  def neighbor? x1, y1, x2, y2
    # TODO
  end

  def normalize index
    # TODO
  end

  def reset
    # TODO
  end

  def get_dead_group x, y
    # TODO
  end

  def expand_dead_group x, y
    # TODO
  end
end
