module Discuz
  class Base < ActiveRecord::Base
    establish_connection 'discuz'
    self.abstract_class = true
  end
end
