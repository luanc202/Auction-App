Rails.application.routes.draw do
  devise_for :users
  root to: 'auction_batches#index'
  resources :auction_items, only: %i[index new create show]
  resources :auction_batches, only: %i[index show new create] do
    post 'approved', on: :member
    get 'add_item', on: :member, to: 'auction_batches#add_item'
    post 'add_item', on: :member, to: 'auction_batches#add_item_save'
    get 'expired', on: :collection
    post 'finished', on: :member
    post 'cancelled', on: :member
    get 'won', on: :collection
    resources :bids, only: %i[create]
  end
  resources :user_fav_batches, only: %i[index create destroy]
end
