require 'rails_helper'

describe 'Usuário adiciona item ao Lote para Leilão' do
  it 'com sucesso' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('HCXA7R2HEK')
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'A4K1L9'
    click_on 'Adicionar Novo Item'
    select 'TV Samsung 32', from: 'Item'
    click_on 'Adicionar Item'

    expect(page).to have_content('TV Samsung 32')
    expect(page).to have_content('A4K1L9')
  end
end
