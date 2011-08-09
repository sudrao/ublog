Ub3::Application.routes.draw do
  resources :uploads

  resource :all
  
  resource :yammer

  resource :twitter
    
# Thumbs is a fake resource, used only to create a separate URL
# for thumbs of photos (assets)
  resources :thumbs, :has_many => :assets
  
# Assets are also available non-nested
  resources :assets

  resources :followers

  resources :friends

  resources :tagsubs
  
  resources :responses

  resources :blogs, :has_many => :uploads

  resources :tags
  
  resources :groups
  
  resources :homes do
    resource :display
    resource :follow
    resources :assets
    resource :toggle_mobile
    resources :threads
  end

  resource :session

  resource :search

# Low priority routes
  match 'log' => 'log#show'
  # match on userid
  match ':vanity' => 'vanity#show'
  match '' => 'homes#index'

end
