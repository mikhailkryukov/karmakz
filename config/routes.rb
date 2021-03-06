Rails.application.routes.draw do
  root 'reviews#recent'

  get  '/about-us',         to: 'static_pages#about_us'
  get  '/help',             to: 'static_pages#help'
  get  '/login',            to: 'sessions#new'
  post '/login',            to: 'sessions#create'
  get  '/logout',           to: 'sessions#destroy'
  get  '/signup',           to: 'users#new'
  get  '/listed-companies', to: 'reviews#listed_companies'
  get  '/find-friend',      to: 'friends#index'
  get  '/search-friend',    to: 'friends#search'
  get  '/search-company',   to: 'companies#search'

  # adding, blocking and rejecting Friends
  post '/users/:user_id/friend/:id/block_user',              to: 'users#block_user', as: 'block_user'
  post '/users/:user_id/friend/:id/add_friend_from_blocked', to: 'users#add_friend_from_blocked', as: 'add_friend_from_blocked'
  post '/users/:user_id/friend/:id/add_friend_from_pending', to: 'users#add_friend_from_pending', as: 'add_friend_from_pending'
  post '/users/:user_id/friend/:id/reject_friendship',       to: 'users#reject_friendship', as: 'reject_friendship'

  resources :users, only: [:index, :create, :edit, :update, :destroy] do
    get 'reviews',        on: :member
    get 'public_reviews', on: :member
    get 'my-friends',     on: :member

    resources :messages, only: [:index, :show, :new, :create, :destroy] do
      member do
        post 'important'
        post 'unimportant'
      end
    end

    resources :companies, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    end

    resources :friends, only: [] do
      post 'send-request', on: :member
    end
  end

  resources :categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :cities,     only: [:index, :new, :create, :edit, :update, :destroy]
  resources :flags,      only: [:index, :create, :destroy]

  resources :reviews, only: [] do
    get    'recent',           on: :collection
    delete 'destroy_by_admin', on: :member
    post   'vote_useful',      on: :member
    post   'vote_funny',       on: :member
    post   'vote_cool',        on: :member
  end

  get '/ui(/:action)', controller: 'ui'

end
