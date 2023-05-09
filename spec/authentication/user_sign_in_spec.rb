require 'rails_helper'

describe 'Usuário se autentica' do
  context 'com sucesso' do
    it 'como usuário' do
      User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: 72653856394)
  
      visit root_path
      within 'nav' do
        click_on 'Entrar'
      end
      fill_in 'E-mail', with: 'paulo@email.com'
      fill_in 'Senha', with: '171653'
      within 'form' do
        click_on 'Entrar'
      end
  
      within 'nav' do
        expect(page).not_to have_link('Entrar')
        expect(page).to have_button('Sair')
        expect(page).to have_content('Paulo | paulo@email.com')
      end
      expect(page).to have_content('Login efetuado com sucesso.')
    end

    it 'como administrador' do
      User.create!(email: 'paulo@leilaodogalpao.com.br', password: '171653', name: 'Paulo', cpf: 72653856394)
  
      visit root_path
      within 'nav' do
        click_on 'Entrar'
      end
      fill_in 'E-mail', with: 'paulo@leilaodogalpao.com.br'
      fill_in 'Senha', with: '171653'
      within 'form' do
        click_on 'Entrar'
      end
  
      within 'nav' do
        expect(page).not_to have_link('Entrar')
        expect(page).to have_button('Sair')
        expect(page).to have_content('Paulo | paulo@leilaodogalpao.com.br')
        expect(page).to have_button('Painel Admin')
      end
      expect(page).to have_content('Login efetuado com sucesso.')
    end
  end

  it 'e faz logout' do
    User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: 72653856394)

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    fill_in 'Senha', with: '171653'
    fill_in 'E-mail', with: 'paulo@email.com'
    within 'form' do
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_content('Logout efetuado com sucesso.')
    within 'nav' do
      expect(page).to have_link('Entrar')
      expect(page).not_to have_button('Sair')
      expect(page).not_to have_content('paulo@email.com')
    end
  end
end
