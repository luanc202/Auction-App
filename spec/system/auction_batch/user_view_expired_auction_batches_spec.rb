require 'rails_helper'

describe 'Usuário visita Lotes para Leilão expirados' do
  it 'não logado' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                  minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!

    visit root_path
    visit expired_batches_path

    expect(current_path).to eq new_user_session_path
  end

  it 'como visitante' do
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                  minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!

    login_as(guest_user)
    visit root_path
    visit expired_batches_path

    expect(page).to have_content('Acesso não autorizado.')
  end

  context 'como admin' do
    it 'vê um lote sem lances' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
      travel_to 5.days.ago
      auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.hours.from_now, minimum_bid_amount: 100,
                                    minimum_bid_difference: 10, created_by_user_id: user.id)
      auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                  height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
      auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                                content_type: 'image/png')
      travel_back

      login_as(user)
      visit root_path
      within 'nav' do
        click_on 'Lotes para Leilão'
      end
      click_on 'Lotes Expirados'

      expect(page).not_to have_button('Aprovar Lote')
      expect(page).to have_button('Cancelar Lote')
      expect(page).to have_content('Lotes Expirados')
      expect(page).to have_content('A4K1L9')
      expect(page).to have_content('Quantidade de itens: 1')
      expect(page).to have_content("Data de início: #{I18n.l(auction_batch.start_date, format: :short)}")
      expect(page).to have_content("Data de término: #{I18n.l(auction_batch.end_date, format: :short)}")
      expect(page).to have_content('Criado por: Julia')
      expect(page).to have_content('Status: Aguardando aprovação')
    end

    it 'vê um lote com lances' do
      guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
      auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
      travel_to 5.days.ago
      batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.hours.from_now, minimum_bid_amount: 100,
                            minimum_bid_difference: 10, created_by_user_id: user.id)
      auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                  height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: batch.id)
      auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                                content_type: 'image/png')
      Bid.create!(batch_id: batch.id, user_id: guest_user.id, value: 100)
      travel_back

      login_as(user)
      visit root_path
      within 'nav' do
        click_on 'Lotes para Leilão'
      end
      click_on 'Lotes Expirados'

      expect(page).not_to have_button('Cancelar Lote')
      expect(page).to have_button('Finalizar Lote')
      expect(page).to have_content('Lotes Expirados')
      expect(page).to have_content('A4K1L9')
      expect(page).to have_content('Quantidade de itens: 1')
      expect(page).to have_content("Data de início: #{I18n.l(batch.start_date, format: :short)}")
      expect(page).to have_content("Data de término: #{I18n.l(batch.end_date, format: :short)}")
      expect(page).to have_content('Criado por: Julia')
      expect(page).to have_content('Status: Aguardando aprovação')
    end
  end
end
