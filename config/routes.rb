Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "events#index"
  resource :events, only: [:index]
  get 'events_page', to: "events#index"
end