class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { user: 0, admin: 1 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :email, :password, :cpf, presence: true

  before_validation :make_admin_if_email, on: :create

  def description
    "#{name} | #{email}"
  end

  def make_admin_if_email
    self.role = :admin if email.split('@').last == 'leilaodogalpao.com.br'
  end
end
