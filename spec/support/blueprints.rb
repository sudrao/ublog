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
      asset_id   { sn }
      owner      { "someone" }
end
