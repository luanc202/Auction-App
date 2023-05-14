class AuctionBatch < ApplicationRecord
  belongs_to :created_by_user, class_name: 'User'
  belongs_to :approved_by_user, class_name: 'User', optional: true

  enum status: { pending: 0, approved: 1, finished: 2 }
end
