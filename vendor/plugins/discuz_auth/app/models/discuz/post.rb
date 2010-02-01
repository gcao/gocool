class Discuz::Post < Discuz::Base
  set_table_name ENV['DISCUZ_TABLE_PREFIX'] + "_posts"
  set_primary_key 'pid'

  has_many :attachments, :class_name => 'Discuz::Attachment', :foreign_key => 'pid'

  default_scope :order => 'pid'

  named_scope :order_by_id_desc, lambda{ {:order => 'pid desc'} }

  def author
    Iconv.conv('utf8', 'gb18030', attributes['author'])
  end

  def subject
    Iconv.conv('utf8', 'gb18030', attributes['subject'])
  end

  def user
    @user ||= User.find_or_create(:username => self.author, :external_id => self.authorid)
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
