Rails.application.routes.draw do
  root 'application#index'

  namespace :api do
    namespace :v1 do
      resources :participants do
        collection do
          get :all
          post :create
        end
      end
      resources :contributions do
        collection do
          get :all
          post :find_all_by_search_term
        end
      end
    end
  end

end
