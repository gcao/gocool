require 'digest/md5'

module CoolGames
  module Md5
    def self.file_to_md5 filename
      %x(/usr/bin/tr -d [:space:] < #{filename} | md5).strip.split(' ').first
    end
    
    def self.string_to_md5 input
      Digest::MD5.hexdigest(input.strip.gsub(/\s+/, ""))
    end
  end
end
