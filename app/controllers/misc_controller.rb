class MiscController < ApplicationController
  def process_newer_posts
    init_processed_counter

    @post_count = 0
    @upload_count = 0

    while true
      posts = Discuz::Post.pid_greater_than(Setting.last_processed_post).paginate(:per_page => 50, :page => 1)
      break if posts.size == 0

      @post_count += posts.size
      posts.each do |post|
        uploads = DiscuzUploader.new.upload post
        @upload_count += uploads.size
        Setting.update(:last_processed_post, post.id)
      end
    end

    render :text => "POST: #{@post_count}, UPLOAD: #{@upload_count}"
  end

  def process_older_posts
    init_processed_counter

    @total = (params[:batch_size] || 1000).to_i
    @post_count = 0
    @upload_count = 0

    while @post_count < @total
      posts = Discuz::Post.order_by_id_desc.pid_less_than(Setting.first_processed_post).paginate(:per_page => 50, :page => 1)
      break if posts.size == 0

      @post_count += posts.size
      posts.each do |post|
        uploads = DiscuzUploader.new.upload post
        @upload_count += uploads.size
        Setting.update(:first_processed_post, post.id)
      end
    end

    render :text => "POST: #{@post_count}, UPLOAD: #{@upload_count}"
  end

  private

  def process_posts

  end

  def init_processed_counter
    if Setting.last_processed_post == 0
      last_processed_post = Discuz::Post.last.id
      Setting.find_by_name('last_processed_post').update_attribute(:value, last_processed_post)
      Setting.find_by_name('first_processed_post').update_attribute(:value, last_processed_post + 1)
    end
  end
end
