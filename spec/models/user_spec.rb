require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'name é obrigatório' do
      user = User.new(email: 'joao@email.com', password: '171653', name: '', cpf: 87_646_343_232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'email é obrigatório' do
      user = User.new(email: '', password: '171653', name: 'João', cpf: 87_646_343_232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'password é obrigatório' do
      user = User.new(email: 'joao@email.com', password: '', name: 'João', cpf: 87_646_343_232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'cpf é obrigatório' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: '')

      result = user.valid?

      expect(result).to eq false
    end

    it 'cpf deve ser válido' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: 11_171_711_111)

      user.valid?

      expect(user.errors.include?(:cpf)).to eq true
      expect(user.errors[:cpf]).to include('deve ser válido')
    end

    it 'cpf deve ter 11 caracteres' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: 637_734)

      user.valid?

      expect(user.errors.include?(:cpf)).to eq true
      expect(user.errors[:cpf]).to include('deve ter 11 dígitos')
    end

    it 'cpf não pode ter todos os números iguais ' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: 11_111_111_111)

      user.valid?

      puts user.errors.full_messages
      expect(user.errors.include?(:cpf)).to eq true
      expect(user.errors[:cpf]).to include('cpf com todos dígitos iguais é inválido')
    end
  end
end
