require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe '#valid?' do
    it 'código deve ser válido' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'AAAB23', start_date: 1.day.from_now, end_date: 7.days.from_now,
                                       minimum_bid_amount: 300, minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:code)).to eq true
      expect(auction_batch.errors[:code]).to include('Deve conter 3 números e 3 letras')
    end

    it 'código é obrigatório' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: '', start_date: 1.day.from_now, end_date: 7.days.from_now,
                                       minimum_bid_amount: 300, minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:code)).to eq true
      expect(auction_batch.errors[:code]).to include('não pode ficar em branco')
    end

    it 'start_date é obrigatório' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'ABC123', start_date: '', end_date: 7.days.from_now,
                                       minimum_bid_amount: 300, minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:start_date)).to eq true
      expect(auction_batch.errors[:start_date]).to include('não pode ficar em branco')
    end

    it 'end_date é obrigatório' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'ABC123', start_date: 1.day.from_now, end_date: '',
                                       minimum_bid_amount: 300, minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:end_date)).to eq true
      expect(auction_batch.errors[:end_date]).to include('não pode ficar em branco')
    end

    it 'minimum_bid_amount é obrigatório' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'ABC123', start_date: 1.day.from_now, end_date: 7.days.from_now,
                                       minimum_bid_amount: '', minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:minimum_bid_amount)).to eq true
      expect(auction_batch.errors[:minimum_bid_amount]).to include('não pode ficar em branco')
    end

    it 'minimum_bid_difference é obrigatório' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'ABC123', start_date: 1.day.from_now, end_date: 7.days.from_now,
                                       minimum_bid_amount: 300, minimum_bid_difference: '', created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:minimum_bid_difference)).to eq true
      expect(auction_batch.errors[:minimum_bid_difference]).to include('não pode ficar em branco')
    end

    it 'start_date deve ser pelo menos 1h no futuro' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'ABC123', start_date: 30.minutes.from_now, end_date: 7.days.from_now,
                                       minimum_bid_amount: 300, minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:start_date)).to eq true
      expect(auction_batch.errors[:start_date]).to include('deve ser pelo menos 1 hora no futuro')
    end

    it 'end_date deve ser pelo menos 12h no futuro' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_batch = Batch.new(code: 'ABC123', start_date: 65.minutes.from_now, end_date: 6.hours.from_now,
                                       minimum_bid_amount: 300, minimum_bid_difference: 10, created_by_user_id: user.id)

      auction_batch.valid?

      expect(auction_batch.errors.include?(:end_date)).to eq true
      expect(auction_batch.errors[:end_date]).to include('deve ser pelo menos 12 horas após a hora de início')
    end
  end
end
