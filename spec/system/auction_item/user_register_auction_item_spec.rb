require 'rails_helper'

describe 'Admin cadastra Item de Leilão' do
  it 'com sucesso' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'),
                              filename: 'tv-imagem.png', content_type: 'image/png')
    allow(SecureRandom).to receive(:alphanumeric).with(10).and_return('HCXA7R2HEK')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Itens para Leilão'
    end
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'TV Philips 40'
    fill_in 'Peso', with: 10_000
    fill_in 'Altura', with: 70
    fill_in 'Largura', with: 50
    fill_in 'Profundidade', with: 10
    attach_file('Foto', 'spec/fixtures/tv-imagem.png')
    fill_in 'Descrição', with: 'Smart TV Philips 40 polegadas HDR LED 4K'
    select 'Eletrônicos', from: 'Categoria'
    click_on 'Criar Item de Leilão'

    expect(page).to have_content('TV Philips 40')
    expect(page).to have_content('Dimensões: 50cm x 70cm x 10cm')
    expect(page).to have_content('Peso: 10000g')
    expect(page).to have_content('Categoria: Eletrônicos')
    expect(page).to have_content('Descrição: Smart TV Philips 40 polegadas HDR LED 4K')
    expect(page).to have_content('Código: HCXA7R2HEK')
    expect(page).to have_css('img[src*="tv-imagem.png"]')
  end

  it 'deve preencher todos os campos' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
    auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                                       height: 70, depth: 10, auction_item_category_id: auction_item_category.id)
    auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'),
                              filename: 'tv-imagem.png', content_type: 'image/png')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Itens para Leilão'
    end
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: ''
    fill_in 'Peso', with: ''
    fill_in 'Altura', with: ''
    fill_in 'Largura', with: ''
    fill_in 'Profundidade', with: ''
    fill_in 'Descrição', with: ''
    select 'Eletrônicos', from: ''
    click_on 'Criar Item de Leilão'

    expect(page).to have_content('Não foi possível cadastrar o Item de Leilão.')
  end
end
