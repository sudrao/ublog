class Blog < ActiveRecord::Base
  validates :content, :home_id, :presence => true
  validates :home_id, :numericality => {:on => :create, :greater_than => 0}
  belongs_to :origin, :class_name => "Home", :foreign_key => "home_id"
  belongs_to :to, :class_name => "Home", :foreign_key => "to_id"
  has_many :taglinks
  has_many :tags, :through => :taglinks
  has_many :uploads

  
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

  def self.join_all(page_size=25, offset=0)  
    # We start with all blogs and outer join with friends, taglinks and tagsubs
    # to be able to include subscriptions.
    joins('LEFT OUTER JOIN friends ON (friends.friend_id = blogs.to_id) OR (friends.friend_id = blogs.home_id)').
      joins('LEFT OUTER JOIN taglinks ON taglinks.blog_id = blogs.id').
      joins('LEFT OUTER JOIN tagsubs ON tagsubs.tag_id = taglinks.tag_id').
      group(:id).order('blogs.created_at DESC').limit(page_size).offset(offset)
  end
        

  # search for blogs to display for one user_id.
  # user_id is the current user's id and home is the page being
  # visited (could be user's home). Owned means the user is on
  # the home page or visiting a page (like a group page) that is
  # owned by him/her. fake_auth means this is for a public feed like
  # rss and private blogs should not be returned.
  def self.mine (user_id, owned, fake_auth, home, page_size=25, offset=0)
    home_id = home.id
    b = Blog.arel_table
    f = Friend.arel_table
    ts = Tagsub.arel_table
    
    not_private = b[:is_private].eq(false)
    on_page = b[:home_id].eq(home_id).or(b[:to_id].eq(home_id))
    p_following = f[:home_id].eq(home_id).and(b[:home_id].eq(f[:friend_id])).and(not_private) # person or group, public blogs
    following = f[:home_id].eq(home_id).and(b[:to_id].eq(f[:friend_id])) # group or reply
    subscribed_tag = ts[:home_id].eq(home_id).and(not_private)
    # when on another (not home) page, check if I am following the private group, too
    # or blog is public or I am the blog writer
    me_following = f[:home_id].eq(user_id).and(f[:is_approved].eq(true)).and(b[:is_private].eq(true))
    own_blog = b[:home_id].eq(user_id)

    j = self.join_all
    # filter the blogs in joined tables case by case
    if (owned and !fake_auth)
      # We are on our home page or another page that we own, so we can use
      # home_id as our own id
      sql = j.where(on_page.or(following).or(p_following).or(subscribed_tag)).to_sql
    elsif (!fake_auth)
      # We are visting someone's page or a group page
      sql = j.where(on_page.and(not_private).or(following.and(not_private)).
                or(p_following).
                or(subscribed_tag.and(not_private)).
                or(on_page.and(own_blog)).
                or(following.and(me_following)).
                or(on_page.and(me_following)).
                or(subscribed_tag.and(own_blog)).
                or(subscribed_tag.and(me_following)).
                or(following.and(own_blog))).to_sql
    else
      sql = j.where(not_private).where(on_page.or(following).or(subscribed_tag)).to_sql 
    end
    logger.debug 'MINESQL: ' + sql        
    find_by_sql(sql) # need this to work around group by generating a 2D array
  end
  
  # Same deal as "mine" but for email enabled friends and tags
  # Here we interested in blogs that would show up on the user's home page
  def self.my_email (user_id, start_time, end_time, page_size=25, offset=0)
    b = Blog.arel_table
    f = Friend.arel_table
    ts = Tagsub.arel_table
    
    not_private = b[:is_private].eq(false)
    to_me = b[:to_id].eq(user_id)
    p_following = f[:home_id].eq(user_id).and(b[:home_id].eq(f[:friend_id])).and(not_private) # person or group, public blogs
    following = f[:home_id].eq(user_id).and(b[:to_id].eq(f[:friend_id])) # group or reply
    approved = f[:is_approved].eq(true)
    subscribed_tag = ts[:home_id].eq(user_id).and(ts[:email_notify].eq(true))
    not_by_me = b[:home_id].not_eq(user_id) # exclude my own blogs

    j = self.join_all
    # filter the blogs in joined tables
    sql = j.where(:created_at => start_time..end_time).where(not_by_me).
            where(following.and(approved).or(following.and(not_private)).or(p_following).or(subscribed_tag).or(to_me)).to_sql
    logger.debug 'EMAILSQL: ' + sql        
    find_by_sql(sql) # need this to work around group by generating a 2D array
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
    webcontent = CGI.escapeHTML(content) # start off with clean content
    webcontent.gsub!(/(https?:\/\/[^ ]*?)([.,;:]?)(( |\Z))/, '<a href="\1" class="ublog-link" target="_top">\1</a>\2\3')
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
    line # already escaped
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
