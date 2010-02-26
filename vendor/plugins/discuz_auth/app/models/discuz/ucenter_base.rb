module Discuz
  class UcenterBase < ActiveRecord::Base
    establish_connection 'ucenter'
    self.abstract_class = true

    def utf8_encoding?
      ENV['DISCUZ_DB_ENCODING'] == 'utf8'
    end
  end
end
