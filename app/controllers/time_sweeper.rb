class TimeSweeper < ActionController::Caching::Sweeper
  # Expire tags page cache every 6 hours
  # We check the time stamp every time someone adds a message
  # which adds overhead
  
  observe Blog
  
  def after_create(blog)
    begin
      stamp = File.mtime("public/tags.html")
#      logger.debug "tags.html has a stamp of #{stamp.to_s}"
      if (Time.now - stamp) > 6.hours
#        logger.debug "Yes, older than 6 hours"
        expire_page "/tags"
        expire_page "/tags.js"
      end
    rescue
      # maybe only the .js file is there
      begin
        stamp = File.mtime("public/tags.js")        
        if (Time.now - stamp) > 6.hours
#          logger.debug "Yes tags.js, older than 6 hours"
          expire_page "/tags.js"
        end
      rescue
        # ignore        
      end
    end
  end
  
end