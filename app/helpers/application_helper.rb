# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    @user
  end

  def blog_when(blog)
    created_time = blog.created_at.localtime
    elapsed = (Time.now - created_time).to_i
    if elapsed < (12 * 3600)
      if elapsed < (2 * 3600)
        if elapsed < (2 * 60)
          elapsed.to_s + " seconds ago"
        else
          (elapsed/60).to_s + " minutes ago"
        end
      else
        (elapsed/3600).to_s + " hours ago"
      end
    else
      created_time.to_s[/^.*?[0-9]+/]
    end
  end
  
  def mydomain
    return ::DOMAIN # provide constant as a view method
  end
end
