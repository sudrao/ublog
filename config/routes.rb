Ub3::Application.routes.draw do
  resource :all
  
  resource :yammer

  resource :twitter
    
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
    resource :toggle_mobile
    resources :threads
  end

  resource :session

  resource :search

# Conventional routes
  match 'log' => 'log#show'
  match 'blogs/new' => 'blogs#new'
# Low priority routes
  # match on userid
  match ':vanity' => 'vanity#show'
  root :to => 'homes#index'

end
