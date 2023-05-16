require 'rails_helper'

describe 'Admin cadastra Lote para Leilão' do
  it 'com sucesso' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
    start_date = 12.hours.from_now
    end_date = 3.days.from_now

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Cadastrar Novo Lote'
    fill_in 'Código', with: '2KL54G'
    fill_in 'Data de início', with: start_date
    fill_in 'Data de término', with: end_date
    fill_in 'Lance inicial', with: 75
    fill_in 'Menor diferença entre lances', with: 10
    click_on 'Criar Lote para Leilão'

    expect(page).to have_content('2KL54G')
    expect(page).to have_content('Quantidade de itens: 0')
    expect(page).to have_content('Data de início: ' + I18n.l(start_date, format: :short))
    expect(page).to have_content('Data de término: ' + I18n.l(end_date, format: :short))
    expect(page).to have_content('Lance inicial: R$ 75,00')
    expect(page).to have_content('Menor diferença entre lances: R$ 10,00')
    expect(page).to have_content('Criado por: Julia')
    expect(page).to have_content('Status: Aguardando aprovação')
    expect(page).not_to have_button('Aprovar Lote')
  end

  it 'deve preencher todos os campos' do
    user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')

    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Lotes para Leilão'
    end
    click_on 'Cadastrar Novo Lote'
    fill_in 'Código', with: ''
    fill_in 'Data de início', with: ''
    fill_in 'Data de término', with: ''
    fill_in 'Lance inicial', with: ''
    fill_in 'Menor diferença entre lances', with: ''
    click_on 'Criar Lote para Leilão'

    expect(page).to have_content('Não foi possível cadastrar o Lote para Leilão.')
  end
end
