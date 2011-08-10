class SearchesController < ApplicationController
  # This is a virtual singleton resource
  before_filter :set_visitor_home
    
  def show
    respond_to do |format|
      format.html { redirect_to homes_path }
      format.mobile { redirect_to homes_path }
      format.xml {render :xml => Home.new.errors, :status => :unprocessable_entity }      
    end
  end
  # POST /searches
  def create
    @home = @visitor_home
    #validate queries with * in it
    @query = params[:query]
    unless invalid_query = @query[/(^\*)|( +\*)/]
      @new_blog = Blog.new
      @new_blog.home_id = @home.id
      result = Home.find_by_solr(@query, :limit => 500)
      @users = result.docs.map { |home| home unless home.is_group and home.is_group == 1 }.compact
      @users.sort! {|u1, u2| u1.ublog_name <=> u2.ublog_name}
      @groups = result.docs.map { |home| home if home.is_group and home.is_group == 1 }.compact
      @groups.sort! {|u1, u2| u1.ublog_name <=> u2.ublog_name}
      result = Blog.find_by_solr(@query, :limit => 500)
      @blogs = result.docs.sort {|b1, b2| b2.created_at <=> b1.created_at}
      result = Tag.find_by_solr(@query, :limit => 500)
      @tags = result.docs.sort {|t1, t2| t1.name <=> t2.name}
    else
      flash[:error] = "Query word cannot start with a *"
      @users = []
      @groups = []
      @blogs = []
      @tags = []
    end
    respond_to do |format|
      format.html { render :action => 'show' }
      format.mobile { render :template => "searches/show.html.erb" }
      format.xml { render :xml => result }      
    end
  end

end
