module Discuz
  class Base < ActiveRecord::Base
    establish_connection ENV['DISCUZ']
    self.abstract_class = true

    include ActiveRecordHelper
  end
end
