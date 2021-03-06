Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  root 'registry_admin#index'
  match '/auth', :to => 'auth#index', :via => [:get,:post]

  resources :registry_admin, :only => :index

  match '/v2', :to => 'registry_admin#api_mapper', :via => [:get]
  match '/v2/*apiaction', :to => 'registry_admin#api_mapper', :via => [:post,:put,:get,:options,:delete,:head]

  match '/auth_mapper', :to => 'registry_admin#auth_mapper', :via => [:post]

  match '/browse', :to => 'registry_admin#index', :via => [:get,:post,:put,:options,:delete,:head]
  match '/browse/*a', :to => 'registry_admin#index', :via => [:get,:post,:put,:options,:delete,:head]

  match '/setup', :to => 'registry_admin#index', :via => [:get,:post,:put,:options,:delete,:head]
  match '/setup/*a', :to => 'registry_admin#index', :via => [:get,:post,:put,:options,:delete,:head]


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
