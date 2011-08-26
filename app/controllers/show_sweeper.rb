class ShowSweeper < ActionController::Caching::Sweeper
  observe Taglink
    
  def after_create(rec)
    expire_page "/tags"
    expire_page "/tags.js"
  end
  
  def after_update(rec)
    expire_page "/tags"
    expire_page "/tags.js"
  end
  
  def after_destroy(rec)
    expire_page "/tags"
    expire_page "/tags.js"
  end
  
end
