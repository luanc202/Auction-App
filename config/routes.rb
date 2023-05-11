Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :auction_items, only: %i[index new create show]
end
