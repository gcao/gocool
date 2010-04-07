class DiscuzUploader
  def logger
    Rails.logger
  end
  
  def upload post
    # fid != 18, 29
    return [] if [18, 29].include?(post.fid)

    # [sgfremote]...[/sgfremote]
    # [dgs]387331[/dgs]
    # http...sgf
    # attachment whose name is ???.sgf
    uploads = []

    sgf_attachments = post.attachments.select{|attachment| attachment.filename =~ /\.sgf/i }
    uploads += sgf_attachments.map {|attachment| upload_attachment post, attachment }

    dgs_games = post.message.scan(/\[dgs\](\d+)\[/i).flatten
    uploads += dgs_games.map {|game_id| upload_dgs_game post, game_id }

    game_urls = post.message.scan(/http:[^:]+\.sgf/i).flatten
    uploads += game_urls.map {|url| upload_game_from post, url}

    remote_games = post.message.scan(/\[sgfremote\]([^\[]+)\[/i).flatten
    uploads += remote_games.map {|url| upload_game_from post, url}

    uploads.compact
  end

  private

  def upload_attachment post, attachment
    return unless attachment.is_sgf?

    desc_hash = post.to_upload_description
    desc_hash[:aid] = attachment.id
    desc_hash[:filename] = attachment.filename

    filename = attachment.path
    if filename !~ /\.sgf$/i
      filename = "/tmp/#{rand(10000)}.sgf"
      `ln -F -s #{attachment.path} #{filename}`
    end

    upload = Upload.create!(:source_type => Upload::UPLOAD_FILE,
                            :file => File.new(filename),
                            :description => desc_hash.inspect,
                            :uploader => post.user.username,
                            :uploader_id => post.user.id)

    upload.update_hash_code
    if found_upload = Upload.with_hash(upload.hash_code).first
      upload.delete
      found_upload
    else
      upload.parse_and_save
      upload
    end
  rescue => e
    logger.error(e.inspect)
  end

  def upload_dgs_game post, dgs_game_id
    url = "http://www.dragongoserver.net/sgf.php?gid=#{dgs_game_id}"
    upload_game_from post, url
  end

  def upload_game_from post, url
    return if url =~ %r(go-cool\.org/app)

    hash_code = Gocool::Md5.string_to_md5 url
    return if Upload.with_hash(hash_code).first

    desc_hash = post.to_upload_description
    upload = Upload.create_from_url desc_hash.inspect, url, hash_code
    upload.uploader = post.user.username
    upload.uploader_id = post.user.id
    upload.save!
    upload
  rescue => e
    logger.error(e.inspect)
  end
end
