class Discuz::PrivateMessage < Discuz::UcenterBase
  set_table_name ENV['UCENTER_TABLE_PREFIX'] + "_pms"
  set_primary_key 'pmid'

  def self.send_message from_user, to_user, subject, message
    create!(:msgfromid => from_user.external_id, :msgfrom => from_user.username, :msgtoid => to_user.external_id,
            :subject => subject, :message => message, :dateline => Time.now.to_i, :new => 1)

    #connection.execute <<-SQL
    #  insert ignore into #{ENV['UCENTER_TABLE_PREFIX']}_newpm(uid) values(#{to_user.external_id})
    #SQL
  end
end
