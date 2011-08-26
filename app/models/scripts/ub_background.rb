require Rails.root.join('lib', 'yammer_api.rb')

class UbBackground
  MAX_EMAIL_BLOGS = 1000
  MAX_EMAIL_FRIENDS = 1000
  MIN_DELAY = 20 # minutes
  EVERY_20_MIN = 1
  HOURLY = 2
  TWICE_A_DAY = 3
  DAILY = 4
  
  def run
    # Setup for Yammer and Twitter
    load_yammer_credentials
    load_twitter_credentials
    
    while true
    # Find and process accounts that need
    # email notification and their time has come
    # NOT WORKING: ActiveRecord::Base.query_cache.clear_query_cache
    stamp = Time.now.utc
    interval = stamp - MIN_DELAY.minutes # 20.minutes.ago in UTC
    # Get a subset of homes that might need notification
    homes = Home.find(:all, :conditions => "notify_calendar > 0 AND last_notified < " + "CAST('" + interval.xmlschema + "' AS datetime)")
    homes.each do |home|
      if (home.notify_calendar == EVERY_20_MIN)
        process(home)
      elsif ((home.notify_calendar == HOURLY) && (home.last_notified < (stamp - 60.minutes)))
        process(home)
      elsif ((home.notify_calendar == TWICE_A_DAY) && (home.last_notified < (stamp - 12.hours)))
        process(home)
      elsif ((home.notify_calendar == DAILY) && (home.last_notified < (stamp - 24.hours)))
        process(home)
      end
    end
    
    # Scan Yammer and Twitter for any #ublog tags and post to ublog
    poll_yammer if ENV['RAILS_ENV'] == 'production'
    poll_twitter if ENV['RAILS_ENV'] == 'production'
    
    # Index newly added blogs in Solr. 
    # We also use the in_solr field to check for cross-posts
    solr_list = Blog.find(:all, :conditions => "in_solr is null or in_solr = 0")
    solr_list.each do |blog|
      # ensure content is utf-8
      solr_blog = blog.clone
      solr_blog.id = blog.id # just for solr, not going to save this
      solr_blog.content = solr_blog.content.toutf8 # force utf8
      solr_blog.solr_save
      # cross post to twitter and yammer
      cross_post(blog) if ENV['RAILS_ENV'] == 'production' # and tags indicate it
      blog.in_solr = 1 # same flag indicates cross-post done
      blog.save      
    end
    solr_list[0].solr_commit if solr_list.length > 0
    
    sleep(60) # sleep 1 minute per loop
    end
  end
  
  private
  
  def load_yammer_credentials
    @y_credentials = YammerAPI::Base.get_yaml_credentials    
  end
  
  def load_twitter_credentials
    @t_credentials = TwitterAPI::Base.get_yaml_credentials    
  end

  def add_blog_to_ublog(blog, user)
    # Check for duplicate before posting here
    last_blog = Blog.last(:conditions => "home_id = #{user.id}")
    unless blog.content.casecmp(last_blog.content) == 0
      blog.save
      blog.taglist.each do |tagname|
        tag = Tag.find_or_create_by_name(tagname)
        if tag
          Taglink.create(:blog_id => blog.id, :tag_id => tag.id)
        end
      end
      blog.solr_save # Commit to solr will happen eventually
    end    
  end
  
  # Scan from Yammer and post to ublog
  def yammer_scan_and_repost(connect)
    connect.updates.each do |u|
#      puts "Checking the content for ublog: '#{u[:content]}'"
      if (hash_ublog? u[:content])
#        puts "Got a #ublog message from #{u[:from]}"
        home = Home.find_by_ublog_name(u[:from])
        if (home and home.yammer_token)
          blog = Blog.new(:home_id => home.id, :content => u[:content][0..139],
            :source => "Yammer", :in_solr => 1)
          add_blog_to_ublog(blog, home)
        end
      end
    end
  end
  
  def poll_yammer
    begin
      connect = YammerAPI::Access.new(@y_credentials)
      saved_info = CrossPost.find(:first)
      if saved_info
        last_id = saved_info.yammer_last_id
      else
        # Create a record to save last_id
        saved_info = CrossPost.new
      end
      # Read after last_id
      new_last_id = connect.read_new_messages(last_id)
      # Save last_id for next poll
      if (new_last_id and (new_last_id != last_id))
        saved_info.update_attributes(:yammer_last_id => new_last_id)
      end
      # Scan yammer messages for #ublog and post to ublog
#    puts "Scanning #{connect.updates.length} messages got from Yammer"
      yammer_scan_and_repost(connect) if new_last_id
    rescue  StandardError, Timeout::Error
      true # ignore
    end
  end

  # Scan from Twitter and post to ublog
  def twitter_scan_and_repost(connect, user)
    connect.updates.each do |u|
#        puts "Checking the content for ublog: '#{u[:content]}'"
      if ((u[:from] == user.twitter_name) and (hash_ublog? u[:content]))
#          puts "Got a #ublog message from #{u[:from]}"
        blog = Blog.new(:home_id => user.id, :content => u[:content][0..139],
          :source => "Twitter", :in_solr => 1)
        add_blog_to_ublog(blog, user)
      end
    end
  end

  def poll_twitter
    # Need to do this per user who asked for it
    users = Home.find(:all, :conditions => "twitter_token is not null")
    user_credentials = @t_credentials.clone
    users.each do |user|
#      puts "Polling twitter for #{user.twitter_name}"
      # override with user's access token
      user_credentials[:access_token] = user.twitter_token
      user_credentials[:access_token_secret] = user.twitter_secret
      last_id = user.twitter_last_id
      begin
        connect = TwitterAPI::Access.new(user_credentials)
        new_last_id = connect.read_new_messages(last_id)
        if (new_last_id and (new_last_id != last_id))
#          puts "Got something. last_id = #{last_id.to_s} new_last_id = #{new_last_id.to_s}. Updating."
          user.update_attributes(:twitter_last_id => new_last_id)
        end
        twitter_scan_and_repost(connect, user) if new_last_id
      rescue StandardError, Timeout::Error
#        puts "Reading twitter failed: " + $!
        true
      end
    end    
  end
  
  # Return access object or nil
  def user_connect_to_yammer(user)
    access = nil
    if user.yammer_token
      user_credentials = @y_credentials.clone # Keep consumer token
      # but override with user's access token
      user_credentials[:access_token] = user.yammer_token
      user_credentials[:access_token_secret] = user.yammer_secret
      begin
        access = YammerAPI::Access.new(user_credentials)
      rescue  StandardError, Timeout::Error
        puts "Failed to access Yammer for user #{user.ublog_name}:\n" + $!
        # Didn't expect this. User needs to get new token sometime.
      end
    end
    access
  end
  
  # Return access object or nil
  def user_connect_to_twitter(user)
    access = nil
    if user.twitter_token
      user_credentials = @t_credentials.clone # Keep consumer token
      # but override with user's access token
      user_credentials[:access_token] = user.twitter_token
      user_credentials[:access_token_secret] = user.twitter_secret
#      puts "Using this token for #{user.ublog_name}: #{user_credentials[:access_token]}/#{user_credentials[:access_token_secret]}"
      begin
        access = TwitterAPI::Access.new(user_credentials)
      rescue  StandardError, Timeout::Error
        puts "Failed to access Twitter for user #{user.ublog_name}:\n" + $!
        # Didn't expect this. User needs to get new token sometime.
      end
    end
    access
  end

  def hash_ublog?(content)
    content[/#ublog([^a-zA-Z0-9]|\Z)/]
  end

  def hash_yam?(content)
    content[/#yam([^a-zA-Z0-9]|\Z)/]
  end
  
  def hash_twt?(content)
    content[/#twt([^a-zA-Z0-9]|\Z)/]
  end
  
  # Yammer and Twitter cross-posting
  # Check for #yam or #tweet in the post and re-post to Yammer or Twitter
  def cross_post(blog)
    user = blog.origin
    return unless user
#    puts "Checking msg from #{blog.origin.ublog_name} with: #{blog.content}"
    if (hash_yam? blog.content)
#      puts "Going to cross-post to Yammer"
      access = user_connect_to_yammer(user)
      if access
        resp = access.post(blog.content)
#        puts "Got this response from yammer for the post:"
#        puts resp.to_s
      end
    end
    if (hash_twt? blog.content)
#      puts "Going to cross-post to Twitter"
      access = user_connect_to_twitter(user)
      if access
        resp = access.post(blog.content)
#        puts "Got this response from twitter for the post:"
#        puts resp.to_s
#        puts resp.body.to_s
      end
    end
  end
  
  def process (home)
#    return unless home.ublog_name == "sudrao" # TESTING TESTING
    # compute the time range to collect blogs
    upper = Time.now.utc - 10.seconds
    lower = home.last_notified
    lowersql = "CAST('" + lower.xmlschema + "' AS datetime)"
    uppersql = "CAST('" + upper.xmlschema + "' AS datetime)"
    blogs = Blog.my_email(home.id, lowersql, uppersql, MAX_EMAIL_BLOGS)

    if (home.is_group && home.is_group == 1)
      Ublogmail.deliver_nudge(home, blogs) if !(home.email_list.blank?) && (blogs.length > 0)
    else
      Ublogmail.deliver_enotify(home.ublog_name, blogs) if blogs.length > 0
    end
#    puts "Blogs to send is " + blogs.length.to_s
    # Finally update time stamp in account
    home.update_attribute(:last_notified, upper)
  end
end

