require 'rails_helper'

describe 'Usuário visita Lote para Leilão expirado' do
  it 'e cancela o lote expirado sem lances' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    travel_to 5.days.ago
    auction_batch = AuctionBatch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.hours.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    travel_back

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lotes Expirados'
    click_on 'Cancelar Lote'

    expect(page).not_to have_button('Aprovar Lote')
    expect(page).not_to have_button('Cancelar Lote')
    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 0')
    expect(page).to have_content('Data de início: ' + I18n.l(auction_batch.start_date, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(auction_batch.end_date, format: :short))
    expect(page).to have_content('Criado por: Julia')
    expect(page).to have_content('Status: Cancelado')
  end

  it 'e finaliza o lote' do
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    travel_to 5.days.ago
    auction_batch = AuctionBatch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.hours.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    bid = Bid.create!(auction_batch_id: auction_batch.id, user_id: guest_user.id, value: 100)
    travel_back

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lotes Expirados'
    click_on 'Finalizar Lote'

    expect(page).not_to have_button('Cancelar Lote')
    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content('Data de início: ' + I18n.l(auction_batch.start_date, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(auction_batch.end_date, format: :short))
    expect(page).to have_content('Criado por: Julia')
    expect(page).to have_content('Status: Finalizado')
  end

  it 'e itens de lote cancelado devem ficar disponíveis novamente' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    travel_to 5.days.ago
    auction_batch = AuctionBatch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.hours.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    second_auction_batch = AuctionBatch.create!(code: '623GQW', start_date: 2.hours.from_now, end_date: 12.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    second_auction_item = AuctionItem.create!(name: 'TV Philips 32', description: 'Philips Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id,)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    travel_back

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lotes Expirados'
    click_on 'Cancelar Lote'
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on '623GQW'
    click_on 'Adicionar Novo Item'
    select 'TV Philips 32', from: 'Item'

    expect(page).to have_select('Item', options: ["TV Philips 32", 'TV Samsung 32'])
  end
end
