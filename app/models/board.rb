class Board < Array
  attr :game_type

  def initialize size, game_type = Game::WEIQI
    @size      = size
    @game_type = game_type
    reset
  end

  def clone
    b = Board.new size, game_type
    0.upto(size - 1) do |x|
      0.upto(size - 1) do |y|
        b[x][y] = self[x][y]
      end
    end
    b
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

  def occupied? x, y
    self[x][y] != 0
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
      return if (x > 0       and self[x-1][y] == 0) or
                (x < @size-1 and self[x+1][y] == 0) or
                (y > 0       and self[x][y-1] == 0) or
                (y < @size-1 and self[x][y+1] == 0)
    end

    group = PointGroup.new(self[x][y])
    group << [x,y]

    if @game_type == Game::DAOQI
      return if expand_dead_group(group, x-1, y) or
                expand_dead_group(group, x+1, y) or
                expand_dead_group(group, x, y-1) or
                expand_dead_group(group, x, y+1)
    else
      return if (x > 0       and expand_dead_group(group, x-1, y)) or
                (x < @size-1 and expand_dead_group(group, x+1, y)) or
                (y > 0       and expand_dead_group(group, x, y-1)) or
                (y < @size-1 and expand_dead_group(group, x, y+1))
    end

    group
  end

#  def md5_hash force = true
#    return @md5_hash if not force and @md5_hash
#
#    @md5_hash = Gocool::Md5.string_to_md5(points_str)
#  end
#
#  def == other
#    game_type == other.game_type and size == other.size and md5_hash == other.md5_hash
#  end

  def points_str
    @points_str = "0" * size * size
    0.upto(size-1) do |x|
      0.upto(size-1) do |y|
        case self[x][y]
          when 1
            @points_str[x*size + y] = "1"
          when 2
            @points_str[x*size + y] = "2"
        end
      end
    end
    @points_str
  end

  def dump
    {
      'size' => size,
      'game_type' => game_type,
      'points' => points_str
    }.to_json
  end

  def self.load input
    hash = JSON.load input
    b = Board.new hash['size'], hash['game_type']
    s = hash['points']
    black_char_code = 49 # '1'
    white_char_code = 50 # '2'
    0.upto(s.length - 1) do |i|
      x = i/b.size
      y = i%b.size
      if s[i] == black_char_code
        b[x][y] = 1
      elsif s[i] == white_char_code
        b[x][y] = 2
      end
    end
    b
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
      return true if (x > 0       and self[x-1][y] == 0) or
                     (x < @size-1 and self[x+1][y] == 0) or
                     (y > 0       and self[x][y-1] == 0) or
                     (y < @size-1 and self[x][y+1] == 0)
    end

    group << [x,y]

    if @game_type == Game::DAOQI
      return true if expand_dead_group(group, x-1, y) or
                     expand_dead_group(group, x+1, y) or
                     expand_dead_group(group, x, y-1) or
                     expand_dead_group(group, x, y+1)
    else
      return true if (x > 0       and expand_dead_group(group, x-1, y)) or
                     (x < @size-1 and expand_dead_group(group, x+1, y)) or
                     (y > 0       and expand_dead_group(group, x, y-1)) or
                     (y < @size-1 and expand_dead_group(group, x, y+1))
    end
  end
end
