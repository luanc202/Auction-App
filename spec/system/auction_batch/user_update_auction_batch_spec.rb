require 'rails_helper'

describe 'Usuário atualiza Lote para Leilão' do
  it 'e aprova o lote' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    user_batch_creator = User.create!(email: 'carlos@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Carlos',
                                      cpf: '91329716051')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user: user_batch_creator)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'A4K1L9'
    click_on 'Aprovar Lote'

    expect(page).to have_content('A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content('Data de início: ' + I18n.l(2.hours.from_now, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(5.days.from_now, format: :short))
    expect(page).to have_content('Lance inicial: R$ 100,00')
    expect(page).to have_content('Menor diferença entre lances: R$ 10,00')
    expect(page).to have_content('Criado por: Carlos')
    expect(page).to have_content('Status: Aprovado')
  end
end
