atom_feed do |feed|
  feed.title "ublog"
  feed.updated((@blogs.first.created_at)) if @blogs.first
  home_id = @home.id
  for blog in @blogs
    origin = blog.origin
    next unless origin
    feed.entry(blog, :url => url_for(@home)) do |entry|
      entry.title("#{origin.ublog_name}: #{blog.content}")
      html_content = link_to(h(origin.ublog_name), home_path(origin)) + ' ' + blog.webify()
      entry.content(html_content, :type => 'html')
      entry.link(url_for(@home))
      entry.author do |author|
        author.name(blog.origin.ublog_name)
      end
    end
  end
end
