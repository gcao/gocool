class Discuz::Post < Discuz::Base
  set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_posts"
  set_primary_key 'pid'

  has_many :attachments, :class_name => 'Discuz::Attachment', :foreign_key => 'pid'

  belongs_to :thread, :class_name => 'Discuz::Thread', :foreign_key => 'tid'

  default_scope :order => 'pid'

  named_scope :order_by_id_desc, lambda{ {:order => 'pid desc'} }

  def author
    if utf8_encoding?
      attributes['author']
    else
      Iconv.conv('utf8', 'gb18030', attributes['author'])
    end
  end

  def subject
    sub = first? ? attributes['subject'] : thread.subject

    if utf8_encoding?
      sub
    else
      Iconv.conv('utf8', 'gb18030', sub)
    end
  end

  def user
    @user ||= User.find_or_load(self.author)
  end

  def to_upload_description
    desc_hash = {}
    %w(pid tid fid subject).each do |field|
      desc_hash[field] = self.send(field)
    end
    desc_hash['upload_time'] = Time.at(self.dateline).strftime("%Y-%m-%d %H:%M")
    desc_hash
  end
end
