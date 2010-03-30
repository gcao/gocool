class Discuz::PrivateMessage < Discuz::UcenterBase
  set_table_name ENV['UCENTER_TABLE_PREFIX'] + "_pms"
  set_primary_key 'pmid'

  def self.send_message from_user, to_user, subject, message
    subject = "GOCOOL" if subject.blank?
    
    create!(:msgfromid => from_user.external_id, :msgfrom => from_user.username, :msgtoid => to_user.external_id,
            :subject => subject, :message => message, :dateline => Time.now.to_i, :new => 1, :folder => 'inbox',
            :fromappid => ENV['UCENTER_MESG_APPID'].to_i)
    create!(:msgfromid => from_user.external_id, :msgfrom => from_user.username, :msgtoid => to_user.external_id,
            :subject => subject, :message => message, :dateline => Time.now.to_i, :new => 1, :folder => 'inbox',
            :related => 1, :fromappid => ENV['UCENTER_MESG_APPID'].to_i)
  end
end
