class VerifyValidCpf
  def initialize(cpf)
    @cpf = cpf
  end

  def check_cpf
    return 'deve ter 11 dígitos' unless valid_cpf_length?
    return 'cpf com todos dígitos iguais é inválido' unless unique_digits?
    return 'deve ser válido' unless valid_digits?

    nil
  end

  private

  def valid_cpf_length?
    @cpf.length == 11
  end

  def unique_digits?
    @cpf.chars.uniq.size != 1
  end

  def valid_digits?
    digit1 = calculate_digit(9)
    digit2 = calculate_digit(10)

    @cpf[-2..] == "#{digit1}#{digit2}"
  end

  def calculate_digit(position)
    n = position == 9 ? 10 : 11
    sum = 0
    position.times { |i| sum += @cpf[i].to_i * (n - i) }
    (sum * 10 % 11) % 10
  end
end
