class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :created_auction_batches, class_name: 'Batch', foreign_key: 'created_by_user_id'
  has_many :approved_auction_batches, class_name: 'Batch', foreign_key: 'approved_by_user_id'
  has_many :bids, dependent: :nullify
  has_many :won_auction_batch, dependent: :nullify
  has_many :user_fav_batch, dependent: :nullify
  has_many :auction_questions, dependent: :nullify
  has_many :auction_questions_reply, dependent: :nullify

  enum role: { user: 0, admin: 1 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :email, :password, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :cpf_must_be_valid
  validate :cpf_blocked

  before_validation :make_admin_if_email, on: :create

  def description
    "#{name} | #{email}"
  end

  private

  def make_admin_if_email
    self.role = :admin if email.split('@').last == 'leilaodogalpao.com.br'
  end

  def cpf_must_be_valid
    verify_valid_cpf = VerifyValidCpf.new(cpf)
    error_message = verify_valid_cpf.check_cpf
    errors.add(:cpf, error_message) unless error_message.nil?
  end

  def cpf_blocked
    return unless BlockedCpf.find_by(cpf:)

    errors.add(:cpf, 'está bloqueado')
    nil
  end
end
