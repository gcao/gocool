module Discuz
  class Base < ActiveRecord::Base
    establish_connection 'discuz'
    self.abstract_class = true

    def utf8_encoding?
      ENV['DISCUZ_DB_ENCODING'] == 'utf8'
    end
  end
end
