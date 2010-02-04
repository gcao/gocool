class Discuz::Attachment < Discuz::Base
  set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_attachments"
  set_primary_key 'aid'

  def is_sgf?
    filename =~ /\.sgf$/i
  end

  def filename
    if utf8_encoding?
      attributes['filename']
    else
      Iconv.conv('utf8', 'gb18030', attributes['filename'])
    end
  end

  def path
    "#{ENV["DISCUZ_HOME"]}/attachments/#{self.attachment}" 
  end
end
