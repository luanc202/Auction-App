class AuctionItem < ApplicationRecord
  belongs_to :auction_item_category
  belongs_to :auction_batch, optional: true
  has_one_attached :image
  before_validation :generate_code, on: :create

  validates :name, :description, :weight, :width, :height, :depth, :auction_item_category_id, presence: true
  validates :code, uniqueness: true

  private 

  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end
end
