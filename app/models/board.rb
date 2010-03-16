class Board < Array
  def initialize size, game_type = Game::WEIQI
    @size = size
    @game_type = game_type
    reset
  end

  def neighbor? x1, y1, x2, y2
    if @game_type == Game::DAOQI
      if x1 == x2
        y1 == (y2+1) % @size or y1 == (y2-1+@size) % @size
      elsif y1 == y2
        x1 == (x2+1) % @size or x1 == (x2-1+@size) % @size
      end
    else
      if x1 == x2
        y1 == y2 + 1 or y1 == y2 - 1
      elsif y1 == y2
        x1 == x2 + 1 or x1 == x2 - 1
      end
    end
  end

  def normalize index
    raise 'normalize() is only applicable to DAOQI' if @game_type == Game::WEIQI

    if index < 0
      index + @size
    elsif index >= @size
      index - @size
    else
      index
    end
  end

  def reset
    for i in 0..@size - 1 do
      self[i] = Array.new @size
      for j in 0..@size - 1 do
        self[i][j] = 0
      end
    end
  end

  def get_dead_group x, y
    if @game_type == Game::DAOQI
      x = normalize(x)
      y = normalize(y)
    else
      return if x < 0 or x>=@size or y<0 or y>= @size
    end

    return if self[x][y] == 0

    if @game_type == Game::DAOQI
      return if self[normalize(x-1)][y] == 0 or
                self[normalize(x+1)][y] == 0 or
                self[x][normalize(y-1)] == 0 or
                self[x][normalize(y+1)] == 0
    else
      return if x > 0       and self[x-1][y] == 0 or
                x < @size-1 and self[x+1][y] == 0 or
                y > 0       and self[x][y-1] == 0 or
                y < @size-1 and self[x][y+1] == 0
    end

    group = PointGroup.new(self[x][y])
    group << [x,y]

    if @game_type == Game::DAOQI
      return if expand_dead_group(group, x-1, y) or
                expand_dead_group(group, x+1, y) or
                expand_dead_group(group, x, y-1) or
                expand_dead_group(group, x, y+1)
    else
      return if x > 0       and expand_dead_group(group, x-1, y) or
                x < @size-1 and expand_dead_group(group, x+1, y) or
                y > 0       and expand_dead_group(group, x, y-1) or
                y < @size-1 and expand_dead_group(group, x, y+1)
    end

    group
  end

  private

  def expand_dead_group group, x, y
    if @game_type == Game::DAOQI
      x = normalize(x)
      y = normalize(y)
    end

    return if group.include?([x, y]) # already added to the group
    return if self[x][y] != group.color

    if @game_type == Game::DAOQI
      return true if self[normalize(x-1)][y] == 0 or
                     self[normalize(x+1)][y] == 0 or
                     self[x][normalize(y-1)] == 0 or
                     self[x][normalize(y+1)] == 0
    else
      return true if x > 0       and self[x-1][y] == 0 or
                     x < @size-1 and self[x+1][y] == 0 or
                     y > 0       and self[x][y-1] == 0 or
                     y < @size-1 and self[x][y+1] == 0
    end

    group << [x,y]

    if @game_type == Game::DAOQI
      return true if expand_dead_group(group, x-1, y) or
                     expand_dead_group(group, x+1, y) or
                     expand_dead_group(group, x, y-1) or
                     expand_dead_group(group, x, y+1)
    else
      return true if x > 0       and expand_dead_group(group, x-1, y) or
                     x < @size-1 and expand_dead_group(group, x+1, y) or
                     y > 0       and expand_dead_group(group, x, y-1) or
                     y < @size-1 and expand_dead_group(group, x, y+1)
    end
  end
end
