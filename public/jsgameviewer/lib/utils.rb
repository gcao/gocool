module Utils
  HLABELS = ['A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T']
  BLACK = 0
  WHITE = 1

  class << self
    def draw_board (grid, size, label_color, label_font, label_font_size)
      vlabelwidth = 20
      hlabelheight = 17
      margin = 2
      width = vlabelwidth + grid*size + 2*margin+2
      height = hlabelheight + grid*size + 2*margin

      # outer border
      gc = Magick::Draw.new
      gc.stroke '#333333'
      gc.fill 'black'
      gc.fill_opacity 0
      gc.stroke_width 2
      x = margin + vlabelwidth + grid/2
      y = margin + grid/2
      w = h = (size-1)*grid
      gc.rectangle(x,y,x+w,y+h)

      # inner grid
      gc.stroke_width 1
      (size-2).times do |i|
        offset = (i+1)*grid
        gc.line(x+offset, y, x+offset, y+h)
        gc.line(x, y+offset, x+w, y+offset)
      end
    
      # star marks
      gc.fill 'black'
      3.times do |i|
        3.times do |j|
          r = 2
          x1 = x+(i*6+3)*grid
          y1 = y+(j*6+3)*grid
          gc.circle(x1, y1, x1+r, y1)
        end
      end
    
      # vetical labels
      gc.stroke 'transparent'
      gc.fill label_color
      gc.font_family label_font
      gc.pointsize label_font_size
      gc.font_weight Magick::BoldWeight
      gc.text_align Magick::RightAlign
      size.times do |i|
        x = vlabelwidth - 3
        y = margin + (i+1)*grid - grid/4 + 1
        label = (size-i).to_s
        gc.text(x,y,label)
      end
    
      # horizontal labels

      gc.text_align(Magick::CenterAlign)
      y = 2*margin + grid*size + grid/2 + 4
      size.times do |i|
        x = vlabelwidth + margin + i*grid + grid/2 + 1
        gc.text(x,y,HLABELS[i])
      end
      
      save_to_file gc, width, height, "./view/images/#{grid.to_s}/board.gif"
    end

    def draw_daoqiboard(grid, size, vbw)
      width = height = grid*(size + 2*vbw)

      # outer border
      gc = Magick::Draw.new
      gc.stroke '#333333'
      gc.fill 'black'
      gc.fill_opacity 0
      gc.stroke_width 1
      x = grid/2
      y = grid/2
      w = h = (size-1 + 2*vbw)*grid
      gc.rectangle(x,y,x+w,y+h)

      # inner grid
      gc.stroke_width 1
      (size + 2*vbw - 2).times do |i|
        offset = (i+1)*grid
        gc.line(x+offset, y, x+offset, y+h)
        gc.line(x, y+offset, x+w, y+offset)
      end
    
      # star marks
      gc.fill 'black'
      3.times do |i|
        3.times do |j|
          r = 2
          x1 = x+(i*6+7)*grid
          y1 = y+(j*6+7)*grid
          gc.circle(x1, y1, x1+r, y1)
        end
      end
    
      save_to_file gc, width, height, "./view/images/#{grid.to_s}/boarddq.gif"
    end

    def draw_vlabel(grid, size, vbw, label_color, label_font, label_font_size)
      daoqisize = size+2*vbw
      vlabelwidth = 20
      vlabelheight = 2*size*grid
      gc = Magick::Draw.new
      gc.stroke 'transparent'
      gc.fill label_color
      gc.font_family label_font
      gc.pointsize label_font_size
      gc.font_weight Magick::BoldWeight
      gc.text_align Magick::RightAlign
      (2*size).times do |i|
        x = vlabelwidth - 3
        y = (i+1)*grid - grid/2
        label = (daoqisize-i%size-8).to_s
        gc.text(x,y,label)
      end
      
      save_to_file gc, vlabelwidth, vlabelheight, "./view/images/#{grid.to_s}/vlabel.gif"
    end

    def draw_hlabel(grid, size, vbw, label_color, label_font, label_font_size)
      daoqisize = size+2*vbw
      hlabelwidth = 2*size*grid
      hlabelheight = 17
      gc = Magick::Draw.new
      gc.stroke 'transparent'
      gc.fill label_color
      gc.font_family label_font
      gc.pointsize label_font_size
      gc.font_weight Magick::BoldWeight
      gc.text_align Magick::RightAlign
      gc.text_align(Magick::CenterAlign)
      y = grid/2 + 4
      (2*size).times do |i|
        x = i*grid + grid/2 + 1
        gc.text(x,y,HLABELS[i%size])
      end
      
      save_to_file gc, hlabelwidth, hlabelheight, "./view/images/#{grid.to_s}/hlabel.gif"
    end

    def init_draw_stone(color, size)
      gc = Magick::Draw.new
      gc.stroke_width 0
      gc.fill_opacity 0
      gc.rectangle(0,0,size,size)
      gc.stroke_width 1
      if (color == BLACK)
        gc.stroke('black')
        gc.fill('black')
        gc.fill_opacity 1
      else
        gc.stroke('#444444')
        gc.fill('white')
        gc.fill_opacity 1
      end
      gc.circle(size/2,size/2, 0,size/2)
      gc
    end

    def draw_stone(color,size,file)
      gc = init_draw_stone(color, size)
      save_to_file gc, size, size, file
    end

    def draw_dead_stone(color,size,file)
      gc = init_draw_stone(color, size)

      # draw cross in red
      gc.stroke 'red'
      gc.stroke_width 2
      gc.line 0,0,size,size
      gc.line 0,size,size,0
      
      save_to_file gc, size, size, file
    end

    def redraw_stone_and_dead_stone(color,size)
      s = (color==BLACK)? "black":"white"
    
      file = "./view/images/#{size.to_s}/#{s}.gif"
      File.delete file if File.exist? file
      draw_stone(color,size,file)
    
      file = "./view/images/#{size.to_s}/#{s}_dead.gif"
      File.delete file if File.exist? file
      draw_dead_stone(color,size,file)
    end

    MARK_MOVE = 0
    MARK_CROSS = 1
    MARK_TRIANGLE = 2
    MARK_SQUARE = 3
    MARK_CIRCLE = 4
    MARK_BLACK_TERRITORY = 5
    MARK_WHITE_TERRITORY = 6

    def draw_mark(type,size)
      gc = Magick::Draw.new
      color = 'red'
      gc.fill color
      gc.fill_opacity 1
      gc.stroke color
      gc.stroke_width 1
      gc.stroke_opacity 1
      gc.stroke_antialias true
      file = "./view/images/#{size.to_s}/"
      case type
      when MARK_MOVE
        file += "markmove.gif"
        gc.polygon(size/3,size/3,size/3,2*size/3,
          2*size/3,2*size/3,2*size/3,size/3)
      when MARK_CROSS
        file += "markcross.gif"
        gc.stroke_width 2
        gc.line size/3,size/3,2*size/3,2*size/3
        gc.line size/3,2*size/3,2*size/3,size/3
      when MARK_TRIANGLE
        file += "marktriangle.gif"
        gc.polygon(size/2,size/4,size/3,5*size/8,2*size/3,5*size/8)
      when MARK_SQUARE
        file += "marksquare.gif"
        gc.polygon(size/3,size/3,size/3,2*size/3,2*size/3,2*size/3,2*size/3,size/3)
      when MARK_CIRCLE
        file += "markcircle.gif"
        gc.circle(size/2,size/2, size/2,(3*size)/4-1)
      when MARK_BLACK_TERRITORY
        file += "markblack.gif"
        gc.fill_opacity 1
        gc.fill 'black'
        gc.stroke_opacity 0.5
        gc.stroke 'red'
        gc.stroke_width 1
        gc.circle(size/2,size/2, size/2,(3*size)/4)
      when MARK_WHITE_TERRITORY
        gc.fill_opacity 1
        gc.fill 'white'
        gc.stroke_opacity 0.5
        gc.stroke 'red'
        gc.stroke_width 1
        gc.circle(size/2,size/2, size/2,(3*size)/4)
        file += "markwhite.gif"
      end
      
      save_to_file gc, size, size, file
    end

    def save_to_file graphics, width, height, file
      canvas = Magick::Image.new(width, height){self.background_color = 'none'}
      graphics.draw canvas
      canvas.write(file)
    end

  end
end

