module Discuz
  class Session < Discuz::Base
    set_table_name ENV['SESSION_TABLE_NAME']
    set_primary_key 'sid'
  end
end
