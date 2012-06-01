require 'open-uri'
require 'nokogiri'

module CoolGames
  module Tom
    class Base
      def base_url
        "http://weiqi.sports.tom.com/"
      end
    end
  
    class HomePage < Base
      def initialize
        @url = base_url
      end
    
      # Return ZhuantiPage list
      def children
        doc = Nokogiri::HTML(open(@url).read, nil, "GB18030")

        zhuanti_pages = []

        doc.css("div.main_tit a").each do |link|
          zhuanti_pages << ZhuantiPage.new(link.content, link['href'])
        end
      
        zhuanti_pages
      end
    end
  
    class ZhuantiPage < Base
      def initialize name, url
        puts "#{name}: #{url}"
        @name = name
        @url  = url
      end
    
      # Return GamePage list
      def children
        game_pages = []
      
        doc = Nokogiri::HTML(open(@url).read, nil, "GB18030")
        doc.css("div.hotinfor a").each do |link|
          href = link['href']
          if href =~ /(http.*html)/
            href = $1
          end
          game_pages << GamePage.new(link.content, href)
        end
      
        game_pages
      end
    end
  
    class GamePage < Base
      attr_reader :name, :url
      
      def initialize name, url
        puts "#{name}: #{url}"
        @name = name
        @url  = url
      end
    
      # Return sgf location
      def sgf_url
        return @sgf_url if @sgf_url
      
        open(@url) do |f|
          while line = f.gets
            if line =~ /name=filename.*(qipu.*\.sgf)/
              return @sgf_url = base_url + $1
            end
          end
        end
      end
    end
  end
end
