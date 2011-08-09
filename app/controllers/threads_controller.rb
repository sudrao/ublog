class ThreadsController < ApplicationController
  before_filter :authenticate
  
  # GET /homes/1/threads/1
  def show
    load_page(params[:home_id].to_i)
    # Get a sorted list of blogs matching this thread
    thread = params[:id]
    @blogs = Blog.find(:all, :conditions => "id = #{thread} or thread = #{thread}",
      :order => "prev_in_thread, created_at")
    @new_blog = Blog.new(:home_id => Home.find_by_ublog_name(@user).id)
    @nothread = true # Don't provide a link to thread again in the blog
    # TODO: should filter out private blogs this user is not authorized to view
    # But letting that go for now. If all were private messages (most likely) then
    # the user would not be able to get here by clicking the thread icon. But
    # it is possible to intentionally construct a /homes/1/threads/1 URL that
    # gets a thread the user is not authorized to view. Final solution is to check each
    # and every blog for a privacy violation.
    
    respond_to do |format|
      format.html
      format.mobile    end
  end
end
