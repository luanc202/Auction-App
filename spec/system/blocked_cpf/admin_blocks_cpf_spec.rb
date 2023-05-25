require 'rails_helper'

describe 'Administrador acessa página de CPFs bloqueados' do
  it 'e adiciona um novo CPF aos CPFs bloqueados' do
    User.create!(email: 'paulo@leilaodogalpao.com.br', password: '171653', name: 'Paulo', cpf: '04206205086')
    BlockedCpf.create!(cpf: '49914857035')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    within 'form#new_user' do
      fill_in 'E-mail', with: 'paulo@leilaodogalpao.com.br'
      fill_in 'Senha', with: '171653'
      click_on 'Entrar'
    end
    click_on 'CPFs Bloqueados'
    fill_in 'Cpf', with: '00742158098'
    click_on 'Bloquear CPF'

    expect(page).to have_content('CPFs bloqueados')
    expect(page).to have_content('49914857035')
    expect(page).to have_content('00742158098')
  end

  it 'e remove um CPF dos CPFs bloqueados' do
    User.create!(email: 'paulo@leilaodogalpao.com.br', password: '171653', name: 'Paulo', cpf: '04206205086')
    BlockedCpf.create!(cpf: '49914857035')
    BlockedCpf.create!(cpf: '00742158098')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    within 'form#new_user' do
      fill_in 'E-mail', with: 'paulo@leilaodogalpao.com.br'
      fill_in 'Senha', with: '171653'
      click_on 'Entrar'
    end
    click_on 'CPFs Bloqueados'
    within 'div#blocked_cpf_2' do
      click_on 'Desbloquear CPF'
    end

    expect(page).to have_content('49914857035')
    expect(page).not_to have_content('00742158098')
  end
end
