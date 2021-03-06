require 'sidekiq/web'
Od::Application.routes.draw do
  # For user managment

  devise_for :admins
  devise_scope :admin do get "/admins/sign_out" => 'devise/sessions#destroy' end
  mount Sidekiq::Web, at: '/sidekiq'

  # Report pages
  resources :reports do
    get 'compare/:compare_id/:id' => 'reports#compare_faculty', as: :compare_faculty
    get 'compare/:id' => 'reports#compare', as: :compare
    get 'faculty/:id' => 'reports#faculty', as: :faculty
  end

  # Openday managment pages
  resources :opendays do
    get 'faculties' => 'opendays#faculties'
    get 'programmes/:id/' => "opendays#programmes", as: :programmes
    get 'timeslots/:id' => "opendays#timeslots", as: :timeslots
    get 'timeslots/edit/:id' => "opendays#edit_timeslots", as: :edit_timeslots

    post 'add_faculties' => 'opendays#add_faculties'
    post 'add_programmes' => 'opendays#add_programmes'
    post 'timeslots/:id' => "opendays#add_timeslots"
    post 'timeslots/update/:id' => "opendays#update_timeslots", as: :update_timeslots
    put 'timeslots/update/:id' => "opendays#update_timeslots"
    patch 'timeslots/update/:id' => "opendays#update_timeslots"
  end

  # Openday faculty/programme managment pages
  resources :faculties do
    resources :programmes
  end
  
  # Registration pages
  resources :registrants
  get  'terms' => 'registrants#terms'

  root 'registrants#index'

  # Route matcher for 404
  #unless ENV["RAILS_ENV"] == 'development'
  #  get '*a', :to => 'application#not_found'
  #end
end
