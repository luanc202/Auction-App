require 'rails_helper'

describe 'User vê lote para leilão' do
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
    within 'nav' do
      click_on 'Lotes para Leilão'
    end

    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content('Preço Atual: R$ 100')
    expect(page).to have_content('Data de início: ' + I18n.l(2.hours.from_now, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(5.days.from_now, format: :short))
  end
  it 'como visitante' do
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    travel_to(2.hour.ago)
    second_auction_batch = Batch.create!(code: '6G42DF', start_date: 1.hour.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                                minimum_bid_difference: 10, created_by_user_id: user.id)
    second_auction_batch.approved!
    travel_back
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    second_auction_item = Item.create!(name: 'TV Philips 40', description: 'Philips TV Smart 40 polegadas HDR OLED 8K', weight: 12_000, width: 60,
                                              height: 90, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: second_auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    second_auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                                     content_type: 'image/png')
    auction_batch.approved!

    login_as(guest_user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end

    within 'div#future-batches' do
      expect(page).to have_content('A4K1L9')
      expect(page).to have_content('Quantidade de itens: 1')
      expect(page).to have_content('Preço Atual: R$ 100')
      expect(page).to have_content('Data de início: ' + I18n.l(2.hours.from_now, format: :short))
      expect(page).to have_content('Data de término: ' + I18n.l(5.days.from_now, format: :short))
    end
    within 'div#ongoing-batches' do
      expect(page).to have_content('6G42DF')
      expect(page).to have_content('Quantidade de itens: 1')
      expect(page).to have_content('Data de início: ' + I18n.l(1.hour.ago, format: :short))
      expect(page).to have_content('Data de término: ' + I18n.l(5.days.from_now - 2.hours, format: :short))
    end
  end

  it 'como admin sucesso' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end

    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content('Preço Atual: R$ 100')
    expect(page).to have_content('Data de início: ' + I18n.l(2.hours.from_now, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(5.days.from_now, format: :short))
    expect(page).to have_content('Criado por: Julia')
    expect(page).to have_content('Status: Aguardando aprovação')
  end

  it 'e não existem lotes para leilão cadastrados' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end

    expect(page).not_to have_content('Acesso não autorizado.')
    expect(page).to have_content('Nenhum Lote em andamento.')
    expect(page).to have_content('Nenhum Lote futuro.')
  end
end
