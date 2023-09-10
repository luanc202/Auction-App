class BlockedCpf < ApplicationRecord
  validates :cpf, presence: true, uniqueness: true
  validate :check_cpf

  private

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

    return if cpf[-2..] == "#{digit1}#{digit2}"

    errors.add(:cpf, 'deve ser válido')
    nil
  end
end
