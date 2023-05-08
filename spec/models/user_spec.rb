require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'name is mandatory' do
      user = User.new(email: 'joao@email.com', password: '171653', name: '', cpf: 87646343232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'email is mandatory' do
      user = User.new(email: '', password: '171653', name: 'João', cpf: 87646343232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'password is mandatory' do
      user = User.new(email: 'joao@email.com', password: '', name: 'João', cpf: 87646343232)

      result = user.valid?

      expect(result).to eq false
    end

    it 'cpf is mandatory' do
      user = User.new(email: 'joao@email.com', password: '171653', name: 'João', cpf: '')

      result = user.valid?

      expect(result).to eq false
    end
  end
end
