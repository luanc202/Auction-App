require 'rails_helper'

describe 'Usuário visita Lote para Leilão' do
  it 'e vê pergunta' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                  minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    auction_batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?')
    AuctionQuestionReply.create!(user:, auction_question: auction_batch.auction_questions.first,
                                 reply: 'Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')

    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lote: A4K1L9'

    expect(page).to have_field('Pergunta')
    expect(page).to have_content('Perguntas')
    expect(page).to have_content('Algum dos itens está danificado ou aberto?')
    expect(page).to have_content('Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')
  end

  it 'e não vê pergunta oculta' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                  minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    auction_batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?',
                                            status: :hidden)
    AuctionQuestionReply.create!(user:, auction_question: auction_batch.auction_questions.first,
                                 reply: 'Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')

    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lote: A4K1L9'

    expect(page).to have_field('Pergunta')
    expect(page).to have_content('Perguntas')
    expect(page).not_to have_content('Algum dos itens está danificado ou aberto?')
    expect(page).not_to have_content('Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')
  end

  it 'e o admin não deve ver formulário de pergunta' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                  minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    auction_batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?',
                                            status: :hidden)
    AuctionQuestionReply.create!(user:, auction_question: auction_batch.auction_questions.first,
                                 reply: 'Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Lote: A4K1L9'

    expect(page).not_to have_field('Pergunta')
  end

  it 'como admin e visita a página de dúvidas não respondidas' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                  minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')
    auction_batch.approved!
    auction_batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?')
    AuctionQuestionReply.create!(user:, auction_question: auction_batch.auction_questions.first,
                                 reply: 'Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')
    auction_batch.auction_questions.create!(user: guest_user, question: 'Estão disponíveis para retirada?')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Perguntas Pendentes'
    end

    expect(page).not_to have_content('Algum dos itens está danificado ou aberto?')
    expect(page).to have_content('Pertence ao lote A4K1L9')
    expect(page).to have_link('A4K1L9', href: batch_path(auction_batch))
    expect(page).to have_content('Feita por: Paulo')
    expect(page).to have_content('Estão disponíveis para retirada?')
    expect(page).to have_field('Resposta')
  end
end
