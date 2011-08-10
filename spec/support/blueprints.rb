require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Home.blueprint do
      ublog_name { "johndoe-#{sn}" }
      name       { "John Doe" }
      owner      { "someone" }
end

Blog.blueprint do
  home_id        { 1 }
  content        { "#{sn}: This is a sample message."}
  is_private     { 0 }
  thread         { sn.to_i + 1 }
  prev_in_thread { sn.to_i }
  proxy          { 'someone' }
  in_solr        { 0 }
end

Blog.blueprint(:with_tag) do
  content { "Hello, my name is #syrah-#{sn}."}
end

Tag.blueprint do
  name { "mytag-#{sn}" }
end
