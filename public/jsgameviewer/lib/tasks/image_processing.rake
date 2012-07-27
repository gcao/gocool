require 'utils'
require 'sprites'

grid                 = 21   # distance between points on board
size                 = 19   # board size
label_color          = '#555555'
label_font           = 'Nina'
label_font_size      = 15

# DAOQI only configurations
daoqigrid            = 19
daoqisize           = 19
vbw                  = 4 # virtual board width
daoqilabel_font_size = 13

desc "Create Weiqi board"
task :board do
  Utils.draw_board(grid, size, label_color, label_font, label_font_size)
end

desc "Create Daoqi board"
task :daoqiboard do
  Utils.draw_daoqiboard(daoqigrid, daoqisize, vbw)
  Utils.draw_hlabel(daoqigrid, size, vbw, label_color, label_font, daoqilabel_font_size)
  Utils.draw_vlabel(daoqigrid, size, vbw, label_color, label_font, daoqilabel_font_size)
end

desc "Create stones"
task :stones do
 Utils.redraw_stone_and_dead_stone(BLACK,15)
 Utils.redraw_stone_and_dead_stone(BLACK,grid)
 Utils.redraw_stone_and_dead_stone(BLACK,daoqigrid)
 Utils.redraw_stone_and_dead_stone(WHITE,15)
 Utils.redraw_stone_and_dead_stone(WHITE,grid)
 Utils.redraw_stone_and_dead_stone(WHITE,daoqigrid)
end

desc "Create marks"
task :marks do
  #Utils.draw_mark(MARK_MOVE,grid)
  #Utils.draw_mark(MARK_MOVE,daoqigrid)
  Utils.draw_mark(MARK_CROSS,grid)
  Utils.draw_mark(MARK_CROSS,daoqigrid)
  Utils.draw_mark(MARK_TRIANGLE,grid)
  Utils.draw_mark(MARK_TRIANGLE,daoqigrid)
  Utils.draw_mark(MARK_SQUARE,grid)
  Utils.draw_mark(MARK_SQUARE,daoqigrid)
  Utils.draw_mark(MARK_CIRCLE,grid)
  Utils.draw_mark(MARK_CIRCLE,daoqigrid)
  Utils.draw_mark(MARK_BLACK_TERRITORY,grid)
  Utils.draw_mark(MARK_BLACK_TERRITORY,daoqigrid)
  Utils.draw_mark(MARK_WHITE_TERRITORY,grid)
  Utils.draw_mark(MARK_WHITE_TERRITORY,daoqigrid)
end

desc "Create all images"
task :images => [:board, :daoqiboard, :stones, :marks]

desc "Create CSS Sprite classes and image"
task :sprites do
  Sprites.to_sprites 'view/images'
  # Current directory is probably changed in above code
  Dir.chdir File.join(File.dirname(__FILE__), "..", "..")
end
