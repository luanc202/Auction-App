class AuctionBatch < ApplicationRecord
  belongs_to :created_by_user, class_name: 'User'
  belongs_to :approved_by_user, class_name: 'User', optional: true
  has_many :auction_items, dependent: :restrict_with_error
  has_many :bids
  has_one :won_auction_batch
  has_many :auction_questions, dependent: :restrict_with_error

  enum status: { pending: 0, approved: 1, finished: 2, cancelled: 3 }

  validates :code, :start_date, :end_date, :minimum_bid_amount, :minimum_bid_difference,
            presence: true
  validates :code, uniqueness: true
  validates :code,
            format: { with: /\A(?=[a-zA-Z]*\d[a-zA-Z]*\d[a-zA-Z]*\d[a-zA-Z]*)[a-zA-Z\d]{6}\z/,
                      message: 'Deve conter 3 números e 3 letras' }
  validate :check_start_date, :check_end_date, on: :create

  private

  def check_start_date
    return unless start_date.present? && start_date < Time.current + 1.hour

    errors.add(:start_date, 'deve ser pelo menos 1 hora no futuro')
  end

  def check_end_date
    return unless end_date.present? && start_date.present? && end_date < start_date + 12.hour

    errors.add(:end_date, 'deve ser pelo menos 12 horas após a hora de início')
  end
end
