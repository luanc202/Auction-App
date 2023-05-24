require 'rails_helper'

describe 'Administrador acessa página de CPFs bloqueados' do
  it 'e vê os cpfs bloqueados' do
    User.create!(email: 'paulo@leilaodogalpao.com.br', password: '171653', name: 'Paulo', cpf: '04206205086')
    BlockedCpf.create!(cpf: '49914857035')
    BlockedCpf.create!(cpf: '00742158098')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'paulo@leilaodogalpao.com.br'
    fill_in 'Senha', with: '171653'
    within 'form' do
      click_on 'Entrar'
    end
    click_on 'CPFs Bloqueados'

    expect(page).to have_content('CPFs bloqueados')
    expect(page).to have_field('Cpf')
    expect(page).to have_content('Bloquear novo CPF')
    expect(page).to have_content('49914857035')
    expect(page).to have_content('00742158098')
    expect(page).to have_button('Desbloquear', count: 2)
  end
end
