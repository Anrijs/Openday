Od::Application.routes.draw do
  devise_for :admins
  devise_scope :admin do get "/admins/sign_out" => 'devise/sessions#destroy' end
  
  resources :reports do
    get 'compare/:compare_id/:id' => 'reports#compare_faculty', as: :compare_faculty
    get 'compare/:id' => 'reports#compare', as: :compare
    get 'faculty/:id' => 'reports#faculty', as: :faculty
  end

  resources :opendays do
    #resources :openday_faculties
    #resources :openday_programmes
    #resources :openday_timeslots
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

  resources :faculties do
    resources :programmes
  end
  
  resources :registrants

  root 'registrants#index'
  get  'terms' => 'registrants#terms'

  unless ENV["RAILS_ENV"] == 'development'
    get '*a', :to => 'application#not_found'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
