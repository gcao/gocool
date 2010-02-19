class Discuz::Member < Discuz::Base
  set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_members"
  set_primary_key 'uid'
end
