class Board < Array
  def initialize size, game_type = Game::WEIQI
    @size = size
    @game_type = game_type
    reset
  end

  def neighbor? x1, y1, x2, y2
    if @game_type == Game::DAOQI
      if x1 == x2
        return y1 == (y2+1) % @size or y1 == (y2-1+@size) % @size
      elsif y1 == y2
        return x1 == (x2+1) % @size or x1 == (x2-1+@size) % @size
      else
        return false
      end
    else
      if x1 == x2
        return y1 == y2+1 or y1 == y2-1
      elsif y1 == y2
        return x1 == x2+1 or x1 == x2-1
      else
        return false
      end
    end
  end

  def normalize index
    if index < 0
      return index + @size
    elsif index >= @size
      return index - @size
    else
      return index
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
    if (this.gameType == Game::DAOQI)
      x = this.normalize(x)
      y = this.normalize(y)
    else
      if (x < 0 || x>=this.size || y<0 || y>= this.size)
        return null
      end
    end

    return nil if (this[x][y] == 0)

    if (this.gameType == Game::DAOQI)
      if (this[this.normalize(x-1)][y] == 0 ||
        this[this.normalize(x+1)][y] == 0 ||
        this[x][this.normalize(y-1)] == 0 ||
        this[x][this.normalize(y+1)] == 0
      )
        return nil
      end
    else
      if ((x > 0 && this[x-1][y] == 0) ||
        (x < this.size-1 && this[x+1][y] == 0) ||
        (y > 0 && this[x][y-1] == 0) ||
        (y < this.size-1 && this[x][y+1] == 0)
      )
        return nil
      end
    end

    group = Array.new
    group.color = this[x][y]
    group.push([x,y])
    group[x+"-"+y] = true

    if (this.gameType == Game::DAOQI)
      return nil if (this.expandDeadGroup(group, x-1, y))
      return nil if (this.expandDeadGroup(group, x+1, y))
      return nil if (this.expandDeadGroup(group, x, y-1))
      return nil if (this.expandDeadGroup(group, x, y+1))
    else
      return nil if (x > 0 && this.expandDeadGroup(group, x-1, y))
      return nil if (x < this.size-1 && this.expandDeadGroup(group, x+1, y))
      return nil if (y > 0 && this.expandDeadGroup(group, x, y-1))
      return nil if (y < this.size-1 && this.expandDeadGroup(group, x, y+1))
    end

    group
  end

  def expand_dead_group x, y
    if (this.gameType == Game::DAOQI)
      x = this.normalize(x)
      y = this.normalize(y)
    end
    return false if (group[x+"-"+y]) # already added to the group
    return false if (this[x][y] != group.color)

    if (this.gameType == Game::DAOQI)
      if (this[this.normalize(x-1)][y] == 0 ||
        this[this.normalize(x+1)][y] == 0 ||
        this[x][this.normalize(y-1)] == 0 ||
        this[x][this.normalize(y+1)] == 0
      )
        return true
      end
    else
      if ((x > 0 && this[x-1][y] == 0) ||
        (x < this.size-1 && this[x+1][y] == 0) ||
        (y > 0 && this[x][y-1] == 0) ||
        (y < this.size-1 && this[x][y+1] == 0)
      )
        return true
      end
    end

    group.push([x,y])
    group[x+"-"+y] = true

    if (this.gameType == Game::DAOQI)
      return true if (this.expandDeadGroup(group, x-1, y))
      return true if (this.expandDeadGroup(group, x+1, y))
      return true if (this.expandDeadGroup(group, x, y-1))
      return true if (this.expandDeadGroup(group, x, y+1))
    else
      return true if (x > 0 && this.expandDeadGroup(group, x-1, y))
      return true if (x < this.size-1 && this.expandDeadGroup(group, x+1, y))
      return true if (y > 0 && this.expandDeadGroup(group, x, y-1))
      return true if (y < this.size-1 && this.expandDeadGroup(group, x, y+1))
    end

    return false
  end
end
