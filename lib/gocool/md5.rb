require 'tempfile'
module Gocool
  module Md5
    def self.file_to_md5 filename
      %x(/usr/bin/tr -d [:space:] < #{filename} | md5).strip
    end
    
    def self.string_to_md5 input
      f = Tempfile.new('sgf')
      f.print input
      f.close
      file_to_md5 f.path
    end
  end
end