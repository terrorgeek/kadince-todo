Rails.application.routes.draw do
  resources :tasks do
    member do
      patch :complete
    end
  end

  root 'tasks#index'
end