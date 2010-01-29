class Discuz::Attachment < Discuz::Base
  set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_attachments"
  set_primary_key 'aid'
end
