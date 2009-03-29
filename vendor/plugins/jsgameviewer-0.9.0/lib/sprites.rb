require 'image_size'
require 'RMagick'
include Magick

def to_sprites(dir)
  dx = 0
  dy = 10
  css_prefix = 'gvsprite-'
  sprite_img = '/jsgameviewer/view/images/sprites.gif'
  excludes = [/sprite.*/,/loading\.gif/]

  Dir.chdir dir
  y = dy / 2
  # depends on ImageMagick
  cmd = "convert "
  sprites = ""
  Dir["**/*.gif"].each do |file|
    next if excludes.detect{|exclude| file =~ exclude}
    #puts file
    size = ImageSize.new(File.open(file))
    img = Image.ping(file)
    w = img[0].columns
    h = img[0].rows
    sprites += ".#{css_prefix}#{file[0..file.index('.')-1].gsub('/','-')}{width: #{w}px; height: #{h}px; background: url(#{sprite_img}) 0 -#{y}px;}\n"
    cmd += "-page +0+#{y} #{file} "
    y += h + dy
  end
  cmd += "-background none -mosaic -bordercolor none sprites.gif"
  system(cmd)

  css_filename = "../default.css"
  css_file = File.open(css_filename + ".new", "w")
  is_sprite = false
  IO.foreach css_filename do |line|
    if line =~ /SPRITES BEGIN/
      css_file.print line
      is_sprite = true
    elsif line =~ /SPRITES END/
      css_file.print sprites
      is_sprite = false
    end
    next if is_sprite
    css_file.print line
  end
  css_file.close
  File.delete css_filename
  File.rename css_file.path, css_filename
end

if __FILE__ == $0
  if ARGV.length == 0
    puts "Usage: #{__FILE__} dir"
    exit
  end
  to_sprites ARGV[0]
end