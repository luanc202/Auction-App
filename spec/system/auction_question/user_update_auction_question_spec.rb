require 'rails_helper'

describe 'Admin visita Lote para Leilão' do
  it 'e esconde uma pergunta' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    auction_batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lote: A4K1L9'
    click_on 'Ocultar pergunta'

    expect(page).to have_content('Status: Oculto')
    expect(page).to have_content('Perguntas')
    expect(page).to have_content('Algum dos itens está danificado ou aberto?')
  end

  it 'e mostra novamente uma pergunta que estava oculta' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    auction_batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?', status: :hidden)

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lote: A4K1L9'
    click_on 'Exibir pergunta'

    expect(page).to have_content('Status: Exibido')
    expect(page).to have_content('Perguntas')
    expect(page).to have_content('Algum dos itens está danificado ou aberto?')
  end
end
