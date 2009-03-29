require 'ftools'
require 'fileutils'
require 'open-uri'
require 'lib/sprites'
require 'lib/utils'
include Utils

grid = 21
size = 19
label_color = '#555555'
label_font = 'Nina'
label_font_size = 15

# DAOQI only configurations
daoqigrid = 19
vbw = 3 # virtual board width
daoqilabel_font_size = 13

task :init

desc "Create Weiqi board"
task :board do
  draw_board(grid, size, label_color, label_font, label_font_size)
end

desc "Create Daoqi board"
task :daoqiboard do
  draw_daoqiboard(daoqigrid, daoqisize)
  draw_vlable(daoqigrid, size, vbw, label_color, label_font, daoqilabel_font_size)
  draw_vlable(daoqigrid, size, vbw, label_color, label_font, daoqilabel_font_size)
end

desc "Create stones"
task :stones do
  redraw_stone(BLACK,grid)
  redraw_stone(BLACK,daoqigrid)
  redraw_stone(WHITE,grid)
  redraw_stone(WHITE,daoqigrid)
end

desc "Create marks"
task :marks do
  #draw_mark(MARK_MOVE,grid)
  #draw_mark(MARK_MOVE,daoqigrid)
  draw_mark(MARK_CROSS,grid)
  draw_mark(MARK_CROSS,daoqigrid)
  draw_mark(MARK_TRIANGLE,grid)
  draw_mark(MARK_TRIANGLE,daoqigrid)
  draw_mark(MARK_SQUARE,grid)
  draw_mark(MARK_SQUARE,daoqigrid)
  draw_mark(MARK_CIRCLE,grid)
  draw_mark(MARK_CIRCLE,daoqigrid)
  draw_mark(MARK_BLACK_TERRITORY,grid)
  draw_mark(MARK_BLACK_TERRITORY,daoqigrid)
  draw_mark(MARK_WHITE_TERRITORY,grid)
  draw_mark(MARK_WHITE_TERRITORY,daoqigrid)
end

desc "Create all images"
task :images => [:board, :daoqiboard, :vlabel, :hlabel, :stones, :marks]

desc "Create CSS Sprite classes and image"
task :sprites do
  to_sprites 'view/images'
end

DIST_DIR = "dist/jsgameviewer/"

task :clean do
  FileUtils.rm_rf DIST_DIR if File.exist? DIST_DIR
end

COMBINED_JS = DIST_DIR + "js/all.js"

file COMBINED_JS => [:init] do
  dir = File.dirname COMBINED_JS
  File.makedirs dir unless File.exist? dir
  File.open(COMBINED_JS, "w") do |file|
    file.print open("http://localhost/jsgameviewer/php/main.php").read
  end
end

desc "Create distribution"
task :dist => [COMBINED_JS] do
  File.makedirs DIST_DIR + "php/cache"
end

FileList['.htaccess', 'index.php', 'gamewindow.php', 'games/*', 'js/*', 'php/*.php', 'view/**/*'].exclude('**/_notes').each do |source|
  target = File.join(DIST_DIR + source)
  puts target
  file target => source do
    if File.directory? source
      File.makedirs target
    else
      File.makedirs File.dirname(target)
      File.copy source, target
    end
  end
  task :dist => target
end

task :default => :dist