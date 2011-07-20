class Blog < ActiveRecord::Base
  validates :content, :home_id, :presence => true
  validates :home_id, :numericality => {:on => :create, :greater_than => 0}
  belongs_to :origin, :class_name => "Home", :foreign_key => "home_id"
  belongs_to :to, :class_name => "Home", :foreign_key => "to_id"
  has_many :taglinks
  has_many :tags, :through => :taglinks
  has_many :main_attachments, :class_name => "Upload", :foreign_key => "blog_id", 
    :conditions => "thumbnail IS NULL"
  
  acts_as_solr :fields => [:content], :auto_add => false, :auto_commit => false
  
  # Get the primary attachment for this blog  
  def attachment
    main_attachments ? main_attachments[0] : nil
  end
  
  # Return all blogs except private ones. Unless the user subscribed 
  # for those groups. Limit and order results
  # LEFT OUTER JOIN will return at least one copy of each blog
  # i.e. from the first mentioned table. This corresponds to "all blogs"
  # However, we check some conditions to eliminate some private blogs.
  # The conditions (WHERE clause) does not guarantee that only one 
  # copy of a blog will result, hence we use GROUP BY to ensure
  # uniqueness of blogs.
  def self.all_blogs(home, page_size=25, offset=0)
    home_id = home.id
    b = Blog.arel_table
    f = Friend.arel_table
    
    not_private = b[:is_private].eq(false)
    own_blog = b[:home_id].eq(home_id)
    subscribed = f[:home_id].eq(home_id).and(f[:is_approved].eq(true)).and(b[:is_private].eq(true))
    
    sql = joins('LEFT OUTER JOIN friends ON friends.friend_id = blogs.to_id').
      where(not_private.or(own_blog).or(subscribed)
        ).group(:id).order('blogs.created_at DESC').limit(page_size).offset(offset).to_sql
        
    find_by_sql(sql) # need this to work around group by generating a 2D array
  end
  
  # search for blogs to display for one user
  def self.mine (user_id, owned, fake_auth, home, page_size=25, offset=0)
    home_idval = home.id
    own_select = owned ? "TRUE" : "FALSE" # use in SQL
    private_select = fake_auth ? "FALSE" : "TRUE"
    blogs_subset = "(SELECT * FROM blogs ORDER BY created_at DESC LIMIT 10000)"

    if (offset == 0)
      # First try with last 10000 blogs to save time
      result = find_mine_by_sql(blogs_subset, home_idval, own_select, private_select,
                 user_id, page_size, offset)
    end
    if (offset > 0) or (result.length < page_size)
      # With full database
      result = find_mine_by_sql("blogs", home_idval, own_select, private_select,
                 user_id, page_size, offset)      
    end
    result
  end
  
  def self.find_mine_by_sql(blogs_set, home_idval, own_select, private_select, user_id,
                              page_size, offset)
    find_by_sql(
    " -- Own blogs and replies to this account
    SELECT b.* FROM #{blogs_set} AS b
    WHERE (b.home_id = #{home_idval} OR b.to_id = #{home_idval}) AND
      ((#{own_select} AND #{private_select}) OR (b.is_private IS NULL OR b.is_private <> 1))
    
    UNION
     -- Friends' originated blogs (non-private)
    SELECT b.* FROM friends as f
    INNER JOIN #{blogs_set} as b
    ON f.friend_id = b.home_id 
    WHERE f.home_id = #{home_idval} AND (b.is_private IS NULL OR b.is_private <> 1)
    
    UNION
      -- Replies to subscribed accounts with private validation
    SELECT b.* FROM #{blogs_set} AS b
    INNER JOIN friends AS f
    ON f.friend_id = b.to_id
    WHERE f.home_id = #{user_id} AND (#{own_select} OR b.to_id = #{home_idval} OR b.home_id = #{home_idval})
    AND ((#{private_select} AND f.is_approved IS NOT NULL AND f.is_approved = 1)  
        OR b.is_private IS NULL OR b.is_private <> 1)
        
    UNION
      -- blogs with subscribed tags (non-private)
    SELECT b.* FROM #{blogs_set} AS b
    INNER JOIN taglinks AS tl
    ON b.id = tl.blog_id
    INNER JOIN tagsubs AS ts
    ON tl.tag_id = ts.tag_id
    WHERE ts.home_id = #{home_idval} AND (b.is_private IS NULL OR b.is_private <> 1)
    GROUP BY id
    ORDER BY created_at DESC
    LIMIT #{offset}, #{page_size}")

  end

  # Same deal as "mine" but for email enabled friends and tags
  def self.my_email (user_id, start_time, end_time, page_size=25, offset=0)
    blogs_subset = "(SELECT * FROM blogs ORDER BY created_at DESC LIMIT 10000)"
    # Assumes much lower than 10,000 blogs per day
    find_my_email_by_sql(blogs_subset, user_id, start_time, end_time, page_size, offset)
  end
  
  def self.find_my_email_by_sql(blogs_set, user_id, start_time, end_time, page_size, offset)
    find_by_sql(
    " -- replies to my account
    SELECT b.* FROM #{blogs_set} AS b
    WHERE b.to_id = #{user_id} AND b.created_at > #{start_time} AND b.created_at <= #{end_time} 
    
    UNION
     -- Friends' originated blogs (non-private)
    SELECT b.* FROM friends as f
    INNER JOIN #{blogs_set} as b
    ON f.friend_id = b.home_id 
    WHERE f.home_id = #{user_id} AND (b.is_private IS NULL OR b.is_private <> 1) AND
      (f.email_notify > 0) AND b.created_at > #{start_time} AND b.created_at <= #{end_time}
    
    UNION
      -- Replies to subscribed accounts with private validation
    SELECT b.* FROM #{blogs_set} AS b
    INNER JOIN friends AS f
    ON f.friend_id = b.to_id
    WHERE f.home_id = #{user_id} AND f.email_notify > 0
    AND b.created_at > #{start_time} AND b.created_at <= #{end_time}
    AND ((f.is_approved IS NOT NULL AND f.is_approved = 1)  
        OR b.is_private IS NULL OR b.is_private <> 1)
        
    UNION
      -- blogs with subscribed tags (non-private)
    SELECT b.* FROM #{blogs_set} AS b
    INNER JOIN taglinks AS tl
    ON b.id = tl.blog_id
    INNER JOIN tagsubs AS ts
    ON tl.tag_id = ts.tag_id
    WHERE ts.home_id = #{user_id} AND (b.is_private IS NULL OR b.is_private <> 1)
    AND ts.email_notify > 0 AND b.created_at > #{start_time} AND b.created_at <= #{end_time}
    GROUP BY id
    ORDER BY created_at DESC
    LIMIT #{offset}, #{page_size}")

  end

  def self.tagged_blogs(tagid, page_size=25, offset=0)
    find_by_sql(
    "SELECT b.* FROM blogs AS b
    INNER JOIN taglinks as tl
    ON tl.blog_id = b.id
    WHERE tl.tag_id = #{tagid} AND
    (b.is_private IS NULL OR b.is_private <> 1)
    GROUP BY b.id
    ORDER BY b.created_at DESC
    LIMIT #{offset}, #{page_size}"
    )
  end
  
  # Gets the tags in blog content
  def taglist
    taglist = []
    # tokenize with non-#/non-alnum/non-$/non-hyphen as separator
    content.split(/[^#\w\$\-]/).each do |token|
      if (token[0] == ?#) # match starting # sign
#        lastchar = token.match(/[.,;:<>]\Z/) ? -2 : -1 # ignore terminal punctuation mark
        tag = token[1..-1].downcase
        # might contain more tags inside
        if tag.include? "#"
          tags = tag.split("#")
        else
          tags = [tag]
        end
        tags.each do |tag|
          # ignore runts and dupes
          next if ((tag.length < 2) or (taglist.include? tag))
          taglist << tag
        end
      end      
    end
    taglist
  end
  
  def webify_http
    webcontent = content.gsub(/(https?:\/\/[^ ]*?)([.,;:]?)(( |\Z))/, '<a href="\1" class="ublog-link" target="_top">\1</a>\2\3')
    # Shorten the displayed URL if long
    runs = webcontent.split("</a>")
    runs.each do |run|
      next unless run.include? '">'
      text = run[/">.*/]
      logger.debug("Link text=\'#{text}\'")
      next if text.length <= 42
      webcontent.sub!(text, text[0..41]+"...")
    end
    webcontent
  end
  
  # return content with html tags
  def webify (my_base="/", make_xml=false)
    tags = taglist # find tags in content
    tags.sort! do |tag1, tag2|
      # reverse sort by length
      tag2.length <=> tag1.length
    end
    # Get tag id for each one
    tagids = tags.map do |tag|
      rec = Tag.find_by_name(tag)
      rec ? rec.id : nil  
    end
    # webify user hyperlinks
    line = webify_http
    # add a span for user content
    line = span_blog_text(line) unless make_xml
    # search and replace tags with hyperlinks
    i = 0
    tags.each do |tag|
      # escape the tag characters to use in regexp
      esctag = ""
      tag.each_char do |char|
        if char[/[$-]/]
          esctag += ("\\" + char)
        else
          esctag += char
        end 
      end
      # Need to ignore case in the gsub 
      line = line.gsub(/(##{esctag})([^\w\$\-]|\Z)/i, "<a href=\"#{my_base}tags/#{tagids[i]}" + '" class="ublog-tag" target="_top">\1</a>\2') if tagids[i]
      logger.debug("This regexp: (##{esctag})([^\w\$\-]|\Z)") if tag.include?('$')
      i += 1
    end
    # replace @reply with hyperlink
    # Find leading (\A) @ followed by repeating non-space (\S) followed by space,
    # ignore rest of line (\s.*)
    if (!make_xml and (line[0] == ?@))
      reply = line.sub(/\A@(\S*?)(\s.*)/, '\1')
      reply_home = Home.find_by_ublog_name(reply) if reply
      reply_id = reply_home.id.to_s if reply_home
      begin
        prev_blog = Blog.find(self.prev_in_thread) if (self.prev_in_thread && (self.prev_in_thread > 0))
        mouseover = prev_blog.origin.ublog_name + " " + prev_blog.content if prev_blog and prev_blog.origin
        mouseover.gsub!('"', "'") if mouseover
      rescue
      end
      mouseover = "" unless mouseover
      line = line.sub(/\A(@.*?) /, "<a href=\"#{my_base}homes/#{reply_id}\" title=\"" + mouseover + '" class="ublog-to" target="_top">\1</a> ') if reply_home
    end
    if (make_xml && (line[0] == ?@))
      # remove @reply from replies
      line = line.sub(/\A(@.*? )/, "")
    end
    line
  end

  def previous
    prev_blog = Blog.find(self.prev_in_thread) if (self.prev_in_thread && (self.prev_in_thread > 0))
    prev_blog.origin.ublog_name + " " + prev_blog.content if prev_blog and prev_blog.origin
  end

  private
  
  def span_blog_text(line)
    # skip any @reply in the beginning
    offset = (line[0] == ?@) ? line.index(' ') : 0 # a blank follows @reply
    offset = 0 unless offset
    if (offset > 0)
      line = line[0..offset] + '<span class="ublog-text">' + line[(offset+1)..-1] + '</span>'
    else
      line = '<span class="ublog-text">' + line + '</span>'
    end
  end
end
