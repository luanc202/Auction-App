require 'rails_helper'

describe 'Usuário busca por um lote' do
  it 'a partir do menu' do
    visit root_path

    within('header nav') do
      expect(page).to have_field('Buscar Lotes')
      expect(page).to have_button('Buscar')
    end
  end

  it 'e encontra um lote' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!

    visit root_path
    fill_in 'Buscar Lotes', with: 'A4K1L9'
    click_on 'Buscar'

    expect(page).to have_content("Resultados da Busca por: A4K1L9")
    expect(page).to have_content('1 lote para leilão encontrado')
    expect(page).to have_content("Lote: A4K1L9")
    expect(page).to have_content('0 item de leilão encontrados')
  end

  it 'e encontra múltiplos pedidos' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    travel_to 5.days.ago
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.days.from_now, minimum_bid_amount: 201,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    second_batch = Batch.create!(code: '2GWD34', start_date: 4.hours.from_now, end_date: 12.days.from_now, minimum_bid_amount: 505,
                                        minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item_2 = AuctionItem.create!(name: 'TV Philips 32', description: 'Philips Smart TV 32 polegadas LCD 2K', weight: 8_000, width: 40,
                                         height: 50, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: second_batch.id)
    auction_item_2.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                                content_type: 'image/png')
    third_batch = Batch.create!(code: 'J3EQ97', start_date: 6.hours.from_now, end_date: 15.days.from_now, minimum_bid_amount: 700,
                                       minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item_3 = AuctionItem.create!(name: 'Mesa de Escritório', description: 'Mesa de escritório em MDF e pernas de aço', weight: 40_000, width: 100,
                                         height: 60, depth: 50, auction_item_category_id: auction_item_category.id, auction_batch_id: third_batch.id)
    auction_item_3.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                                content_type: 'image/png')
    travel_back

    visit root_path
    fill_in 'Buscar Lotes', with: 'TV'
    click_on 'Buscar'

    expect(page).to have_content("Resultados da Busca por: TV")
    expect(page).to have_content('0 lote para leilão encontrados')
    expect(page).to have_content("Lote: A4K1L9")
    expect(page).to have_content("Lote: 2GWD34")
    expect(page).to have_content('2 item de leilão encontrados')
    expect(page).to have_content('TV Samsung 32')
    expect(page).to have_content('TV Philips 32')
    expect(page).not_to have_content('Mesa de Escritório')
    expect(page).not_to have_content('J3EQ97')
  end
end
