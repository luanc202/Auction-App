class AuctionQuestion < ApplicationRecord
  belongs_to :user
  belongs_to :auction_batch
  has_one :auction_question_reply

  enum status: { display: 0, hidden: 1 }
end
