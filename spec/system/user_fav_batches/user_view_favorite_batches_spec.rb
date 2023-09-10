require 'rails_helper'

describe 'User vê lotes favoritos' do
  it 'a partir do menu' do
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                          minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    batch.approved!
    UserFavBatch.create!(user: guest_user, batch:)

    login_as(guest_user)
    visit root_path
    within 'nav' do
      click_on 'Lotes Favoritos'
    end

    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content("Data de início: #{I18n.l(2.hours.from_now, format: :short)}")
    expect(page).to have_content("Data de término: #{I18n.l(5.days.from_now, format: :short)}")
    expect(page).to have_content('Preço Atual: R$ 100')
  end

  it 'e não existem favoritos cadastrados' do
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')

    login_as(guest_user)
    visit root_path
    within 'nav' do
      click_on 'Lotes Favoritos'
    end

    expect(page).to have_content('Nenhum Lote adicionado aos favoritos.')
  end
end
