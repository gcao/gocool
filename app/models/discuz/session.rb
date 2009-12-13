module Discuz
  class Session < Discuz::Base
    set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_sessions"
    set_primary_key 'sid'
  end
end
