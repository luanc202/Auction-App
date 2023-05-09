require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'name é obrigatório' do
      user = User.new(email: 'joao@email.com', password: '171653', name: '', cpf: 87646343232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'email é obrigatório' do
      user = User.new(email: '', password: '171653', name: 'João', cpf: 87646343232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'password é obrigatório' do
      user = User.new(email: 'joao@email.com', password: '', name: 'João', cpf: 87646343232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'cpf é obrigatório' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: '')

      result = user.valid?

      expect(result).to eq false
    end

    it 'cpf deve ser válido' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: 11171711111)

      result = user.valid?

      expect(user.errors.include?(:cpf)).to eq true
      expect(user.errors[:cpf]).to include('deve ser válido')
    end

    it 'cpf deve ter 11 caracteres' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: 637734)

      result = user.valid?

      expect(user.errors.include?(:cpf)).to eq true
      expect(user.errors[:cpf]).to include('deve ter 11 dígitos')
    end

    it 'cpf não pode ter todos os números iguais ' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: 11111111111)

      result = user.valid?

      expect(user.errors.include?(:cpf)).to eq true
      expect(user.errors[:cpf]).to include('cpf com todos dígitos iguais é inválido')
    end
  end
end
