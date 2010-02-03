class Discuz::Thread < Discuz::Base
  set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_threads"
  set_primary_key 'tid'
end
