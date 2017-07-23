Rails.application.routes.draw do
  resources :roles, except: %i[show]
  resources :users, except: %i[show]
  resources :projects, except: %i[show] do
    resources :tasks, except: %i[show]
  end

  get "sign_in_as/:id", to: "session#sign_in_as", as: :sign_in_as
  delete "sign_out", to: "session#sign_out", as: :sign_out

  root "home#index"
end
