require 'rails_helper'

describe 'User vê itens para leilão' do
  it 'não logado' do
    visit root_path
    visit items_path

    expect(current_path).to eq new_user_session_path
  end
  context 'se estiver autenticado' do
    it 'como visitante' do
      user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '04206205086')

      login_as(user)
      visit root_path
      visit items_path

      expect(current_path).to eq root_path
      expect(page).to have_content('Acesso não autorizado.')
    end

    it 'como admin' do
      user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')

      login_as(user)
      visit root_path
      within 'nav' do
        click_on 'Itens para Leilão'
      end

      expect(current_path).to eq items_path
    end
  end

  it 'com sucesso' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id)
    auction_item.image.attach(io: File.open("spec/fixtures/tv-imagem.png"), filename: 'tv-imagem.png', content_type: 'image/png')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Itens para Leilão'
    end

    expect(page).not_to have_content('Acesso não autorizado.')
    expect(page).to have_content('TV Samsung 32')
    expect(page).to have_content('Descrição: Samsung Smart TV 32 polegadas HDR LED 4K')
    expect(page).to have_content('Dimensões: 50cm x 70cm x 10cm')
    expect(page).to have_content('Peso: 10000g')
    expect(page).to have_content('Categoria: Eletrônicos')
    expect(page).to have_content("Código: #{auction_item.code}")
    expect(page).to have_css('img[src*="tv-imagem.png"]')
  end

  it 'e não existem produtos cadastrados' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Itens para Leilão'
    end

    expect(page).to have_content('Nenhum Item de Leilão cadastrado.')
  end
end
