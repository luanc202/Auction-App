class UserFavBatch < ApplicationRecord
  belongs_to :user
  belongs_to :auction_batch
end
