class Point
  attr_reader :x, :y, :id, :color, :move_no

  def initialize x, y, color, move_no, delete = nil
    @x = x
    @y = y
    @id = "#{x}-#{y}"
    @color = color
    @move_no = move_no
    @delete = delete
  end

  def delete?
    @delete
  end
end
