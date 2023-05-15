require 'rails_helper'

describe 'User vê lote para leilão' do
  it 'não logado' do
    visit root_path
    visit auction_batches_path

    expect(current_path).to eq new_user_session_path
  end
  context 'se estiver autenticado' do
    it 'como visitante' do
      user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '04206205086')

      login_as(user)
      visit root_path
      visit auction_batches_path

      expect(current_path).to eq root_path
      expect(page).to have_content('Acesso não autorizado.')
    end

    it 'como admin' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')

      login_as(user)
      visit root_path
      within 'nav' do
        click_on 'Lotes para Leilão'
      end

      expect(current_path).to eq auction_batches_path
    end
  end

  it 'com sucesso' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_batch = AuctionBatch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 5.days.from_now, minimum_bid_amount: 100,
                                         minimum_bid_difference: 10, created_by_user_id: user.id)
    auction_item = AuctionItem.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id, auction_batch_id: auction_batch.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                              content_type: 'image/png')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end

    expect(page).not_to have_content('Acesso não autorizado.')
    expect(page).to have_content('Lotes para Leilão')
    expect(page).to have_content('Lote: A4K1L9')
    expect(page).to have_content('Quantidade de itens: 1')
    expect(page).to have_content('Data de início: ' + I18n.l(2.hours.from_now, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(5.days.from_now, format: :short))
    expect(page).to have_content('Criado por: Julia')
  end

  it 'e não existem lotes para leilão cadastrados' do
  end
end
