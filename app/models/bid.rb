class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction_batch

  validates :value, presence: true
  validate :check_if_exists_bids
  validate :check_last_bid_value

  private

  def check_if_exists_bids
    return unless value < auction_batch.minimum_bid_amount

    errors.add(:value, 'Valor do lance é inferior ao mínimo do lance inicial')
  end

  def check_last_bid_value
    return if auction_batch.bids.empty? || value >= auction_batch.minimum_bid_difference + auction_batch.bids.last.value

    errors.add(:value, 'Valor do lance é inferior ao mínimo exigido')
  end
end
