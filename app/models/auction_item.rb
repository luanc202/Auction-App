class AuctionItem < ApplicationRecord
  belongs_to :auction_item_category
  has_one_attached :image
end
