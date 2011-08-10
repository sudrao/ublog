class BuildSolr < ActiveRecord::Base
  
  def self.run
    blogs = Blog.find(:all, :conditions => "is_private is null or is_private = 0")
    homes = Home.find(:all)
    tags = Tag.find(:all)

    form = REXML::Formatters::Pretty.new
    
    File.open("ublog_base.xml", "w") do |f|
    
    f.puts "<add>\n"
    
    blogs.each do |blog|
      begin
        form.write blog.to_solr_doc.to_xml, f
      rescue
        # ignore errors for now
        f.flush
        f.puts "</field></doc>\n"
        form = REXML::Formatters::Pretty.new
      end
    end
    
    homes.each do |home|
      begin
        form.write home.to_solr_doc.to_xml, f
      rescue
        # ignore errors for now
        f.flush
        f.puts "</field></doc>\n"
        form = REXML::Formatters::Pretty.new
      end
    end
    
    tags.each do |tag|
      begin
        form.write tag.to_solr_doc.to_xml, f
      rescue
        # ignore errors for now
        f.flush
        f.puts "</field></doc>\n"
        form = REXML::Formatters::Pretty.new
      end
    end
    
    f.puts "\n</add>\n"
    end
  end
end