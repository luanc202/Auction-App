class AuctionItemCategory < ApplicationRecord
  has_many :auction_items, dependent: :restrict_with_error
end
