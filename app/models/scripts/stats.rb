class Stats < ActiveRecord::Base
  def self.run
    # Show count of user/ groups
    users = Home.count(:conditions => "is_group is null or is_group = 0")
    groups = Home.count(:conditions => "is_group > 0")
    blogs = Blog.count
    # Top posters. In the last 7 days who posted the most
    days_back = 7.days.ago.utc.xmlschema
    recent_blogs = Blog.find(:all, 
      :conditions => "created_at >= CAST('#{days_back}' AS datetime)",
      :select => "id, home_id")
    recent_count = recent_blogs.count
    top_users = {}
    recent_blogs.each do |blog|
      who = blog.home_id
      count = top_users[who]
      top_users[who] = count ? count+1 : 1
    end
    sorted_list = []
    top_users.each do |who, count|
      sorted_list << who
    end
    sorted_list.sort! do |s1, s2|
      top_users[s2] <=> top_users[s1]
    end
    puts "Users = #{users}. Groups = #{groups}. Blogs = #{blogs} (#{recent_count} recent)"
    puts "#{top_users.length} users in the last 7 days:"
    list = ""
    sorted_list.each do |who|
      list << "#{Home.find(who).ublog_name} (#{top_users[who].to_s}), " if Home.find(who)
    end
    puts list
  end
end