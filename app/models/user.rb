class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :created_auction_batches, class_name: 'AuctionBatch', foreign_key: 'created_by_user_id'
  has_many :approved_auction_batches, class_name: 'AuctionBatch', foreign_key: 'approved_by_user_id'
  has_many :bids
  has_many :won_auction_batch
  has_many :user_fav_batch
  has_many :auction_questions
  has_many :auction_questions_reply

  enum role: { user: 0, admin: 1 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :email, :password, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :check_cpf
  validate :cpf_blocked

  before_validation :make_admin_if_email, on: :create

  def description
    "#{name} | #{email}"
  end

  private

  def make_admin_if_email
    self.role = :admin if email.split('@').last == 'leilaodogalpao.com.br'
  end

  def check_cpf
    if cpf.length != 11
      errors.add(:cpf, 'deve ter 11 dígitos')
      return
    end

    if cpf.chars.uniq.size == 1
      errors.add(:cpf, 'cpf com todos dígitos iguais é inválido')
      return
    end

    sum = 0
    9.times { |i| sum += cpf[i].to_i * (10 - i) }
    digit1 = (sum * 10 % 11) % 10

    sum = 0
    10.times { |i| sum += cpf[i].to_i * (11 - i) }
    digit2 = (sum * 10 % 11) % 10

    return if cpf[-2..-1] == "#{digit1}#{digit2}"

    errors.add(:cpf, 'deve ser válido')
    nil
  end

  def cpf_blocked
    return unless BlockedCpf.find_by(cpf:)

    errors.add(:cpf, 'está bloqueado')
    nil
  end
end
