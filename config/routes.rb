Rails.application.routes.draw do
  root 'application#index'

  resources :contributions
  resources :participants

  namespace :api do
    namespace :v1 do
      resources :participants do
        collection do
          post :create
          get :find_all
        end
      end
      resources :contributions do
        collection do
          post :create_sso
          post :create_cleaning_record
          post :destroy
          get :find_all
          post :find_all_by_search_term
        end
      end
      resources :assets do
        collection do
          post :find_all_by_coordinates
        end
      end
    end
  end

end
