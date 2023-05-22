class AuctionQuestionReply < ApplicationRecord
  belongs_to :user
  belongs_to :auction_question
end
