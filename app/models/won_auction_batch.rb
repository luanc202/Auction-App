class WonAuctionBatch < ApplicationRecord
  belongs_to :auction_batch
  belongs_to :user
end
