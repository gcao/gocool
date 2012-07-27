def game_types
  %w(weiqi daoqi)
end

def locales
  Dir[File.join(File.dirname(__FILE__), "..", "translations", "*.yml"].map {|filename| $1 if filename =~ /([^\/]+)\.yml$/}
end

def game_types_and_locales
  answer = []
  game_types.each do |game_type|
    locales.each do |locale|
      answer << [game_type, locale]
    end
  end
  answer
end