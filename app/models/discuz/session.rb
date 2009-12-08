module Discuz
  class Session < Discuz::Base
    set_table_name ENV['DISCUZ_SESSIONS_TABLE']
    set_primary_key 'sid'
  end
end
