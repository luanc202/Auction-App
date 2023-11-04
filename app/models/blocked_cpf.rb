class BlockedCpf < ApplicationRecord
  validates :cpf, presence: true, uniqueness: true
  validate :check_cpf

  private

  def check_cpf
    verify_valid_cpf = VerifyValidCpf.new(cpf)
    error_message = verify_valid_cpf.check_cpf
    errors.add(:cpf, error_message) unless error_message.nil?
  end
end
