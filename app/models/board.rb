class Board < Array
  attr :game_type

  CHARS = "0123456789:"

  NONE            = 0
  BLACK           = 1
  WHITE           = 2
  BLACK_DEAD      = 3
  WHITE_DEAD      = 4
  BLACK_TERRITORY = 5
  WHITE_TERRITORY = 6
  SHARED          = 9
  DAME            = 10 # dan guan
  VISITED         = 99

  def initialize size, game_type = Game::WEIQI
    @size      = size
    @game_type = game_type
    reset
  end

  def daoqi?
    @game_type == Game::DAOQI
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

  def inspect
    "\n" + map(&:inspect).join("\n")
  end

  def neighbor? x1, y1, x2, y2
    if daoqi?
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

  def play color, x, y
    return [] if color == 0

    self[x][y] = color

    dead = []
    remove_group = lambda do |group|
      if group
        group.each do |x, y|
          dead << [x, y]
          self[x][y] = 0
        end
      end
    end
    
    opponent_color = color == BLACK ? WHITE : BLACK

    remove_group.call get_dead_group(x-1, y) if (@game_type == Game::DAOQI or x > 0        ) and self[x-1][y] == opponent_color
    remove_group.call get_dead_group(x+1, y) if (@game_type == Game::DAOQI or x < @size - 1) and self[x+1][y] == opponent_color
    remove_group.call get_dead_group(x, y-1) if (@game_type == Game::DAOQI or y > 0        ) and self[x][y-1] == opponent_color
    remove_group.call get_dead_group(x, y+1) if (@game_type == Game::DAOQI or y < @size - 1) and self[x][y+1] == opponent_color
    
    remove_group.call get_dead_group(x, y)

    dead
  end

  def count whose_turn
    mark_territories
    finish_dame whose_turn

    b = w = 0
    for i in 0..@size - 1
      for j in 0..@size - 1
        case self[i][j]
          when BLACK, BLACK_TERRITORY, WHITE_DEAD
            b += 1
          when WHITE, WHITE_TERRITORY, BLACK_DEAD
            w += 1
          when SHARED
            b += 0.5
            w += 0.5
        end
      end
    end

    return b, w
  end

  def get_dead_group x, y
    if daoqi?
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

    return if ((daoqi? or x > 0      ) and expand_dead_group(group, x-1, y)) or
              ((daoqi? or x < @size-1) and expand_dead_group(group, x+1, y)) or
              ((daoqi? or y > 0      ) and expand_dead_group(group, x, y-1)) or
              ((daoqi? or y < @size-1) and expand_dead_group(group, x, y+1))

    group
  end

  def get_dead_group_for_marking x, y
    if daoqi?
      x = normalize(x)
      y = normalize(y)
    else
      return if x < 0 or x>=@size or y<0 or y>= @size
    end

    return if self[x][y] == 0

    group = PointGroup.new(self[x][y])
    group << [x,y]

    expand_dead_group_for_marking(group, x-1, y) if daoqi? or x > 0
    expand_dead_group_for_marking(group, x+1, y) if daoqi? or x < @size-1
    expand_dead_group_for_marking(group, x, y-1) if daoqi? or y > 0
    expand_dead_group_for_marking(group, x, y+1) if daoqi? or y < @size-1

    group.reject! {|point| self[point[0]][point[1]] == 0}
    group
  end

  def mark_dead_group group
    group.each do |x, y|
      if self[x][y] == 1
        self[x][y] = BLACK_DEAD
      elsif self[x][y] == 2
        self[x][y] = WHITE_DEAD
      end
    end
  end

  def mark_territories
    for i in 0..@size - 1
      for j in 0..@size - 1
        if self[i][j] == 0
          @black_neighbor = @white_neighbor = false
          group = expand_blank_group i, j
          unless group.blank?
            if @black_neighbor and @white_neighbor
              group.each{|x, y| self[x][y] = DAME }
            elsif @black_neighbor
              group.each{|x, y| self[x][y] = BLACK_TERRITORY }
            elsif @white_neighbor
              group.each{|x, y| self[x][y] = WHITE_TERRITORY }
            else
              group.each{|x, y| self[x][y] = DAME }
            end
          end
        end
      end
    end
  end

  def finish_dame whose_turn
    for i in 0..@size - 1
      for j in 0..@size - 1
        if self[i][j] == DAME
          if whose_turn == 1
            self[i][j] = BLACK_TERRITORY
            whose_turn = 2
          else
            self[i][j] = WHITE_TERRITORY
            whose_turn = 1
          end
        end
      end
    end
  end

  def points_str
    @points_str = "0" * size * size
    0.upto(size-1) do |x|
      0.upto(size-1) do |y|
        @points_str[x*size + y] = CHARS[self[x][y], 1]
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
    start_char_code = 48 # '0'
    0.upto(s.length - 1) do |i|
      x = i/b.size
      y = i%b.size
      b[x][y] = s[i].ord - start_char_code # TODO: String#ord works in Ruby 1.9 only
    end
    b
  end

  private

  def expand_dead_group group, x, y
    if daoqi?
      x = normalize(x)
      y = normalize(y)
    end

    return if group.include?([x, y]) # already added to the group
    return if self[x][y] != group.color

    if daoqi?
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

    ((daoqi? or x > 0      ) and expand_dead_group(group, x-1, y)) or
    ((daoqi? or x < @size-1) and expand_dead_group(group, x+1, y)) or
    ((daoqi? or y > 0      ) and expand_dead_group(group, x, y-1)) or
    ((daoqi? or y < @size-1) and expand_dead_group(group, x, y+1))
  end

  def expand_dead_group_for_marking group, x, y
    if daoqi?
      x = normalize(x)
      y = normalize(y)
    end

    return if group.include?([x, y]) # already added to the group

    opponent_color = group.color == 1 ? 2 : 1
    return if self[x][y] == opponent_color

    group << [x,y]

    expand_dead_group_for_marking(group, x-1, y) if daoqi? or x > 0
    expand_dead_group_for_marking(group, x+1, y) if daoqi? or x < @size-1
    expand_dead_group_for_marking(group, x, y-1) if daoqi? or y > 0
    expand_dead_group_for_marking(group, x, y+1) if daoqi? or y < @size-1
  end

  def expand_blank_group x, y, group = nil
    if daoqi?
      x = normalize(x)
      y = normalize(y)
    end

    case self[x][y]
    when 0
      group ||= []
      group << [x, y]
      self[x][y] = VISITED
      expand_blank_group(x-1,y,group) if daoqi? or x > 0
      expand_blank_group(x+1,y,group) if daoqi? or x < @size-1
      expand_blank_group(x,y-1,group) if daoqi? or y > 0
      expand_blank_group(x,y+1,group) if daoqi? or y < @size-1
    when 1, WHITE_DEAD
      @black_neighbor = true
    when 2, BLACK_DEAD
      @white_neighbor = true
    end

    group
  end
end
