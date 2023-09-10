require 'rails_helper'

describe 'Usuário visita Lote para Leilão expirado' do
  it 'e finaliza o lote' do
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
    batch.finished!
    WonAuctionBatch.create!(batch:, user: guest_user)

    login_as(guest_user)
    visit root_path
    within 'nav' do
      click_on 'Leilões Vencidos'
    end

    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content("Data de término: #{I18n.l(batch.end_date, format: :short)}")
    expect(page).to have_content('TV Samsung 32')
    expect(page).to have_content('Samsung Smart TV 32 polegadas HDR LED 4K')
    expect(page).to have_content('Dimensões: 50cm x 70cm x 10cm')
    expect(page).to have_content('Peso: 10000g')
    expect(page).to have_content('Categoria: Eletrônicos')
    expect(page).to have_css('img[src*="tv-imagem.png"]')
  end
end
