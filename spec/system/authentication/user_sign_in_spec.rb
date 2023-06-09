require 'rails_helper'

describe 'Usuário se autentica' do
  context 'com sucesso' do
    it 'como usuário' do
      User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '04206205086')

      visit root_path
      within 'nav' do
        click_on 'Entrar'
      end
      fill_in 'E-mail', with: 'paulo@email.com'
      fill_in 'Senha', with: '171653'
      within 'form#new_user' do
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
      User.create!(email: 'paulo@leilaodogalpao.com.br', password: '171653', name: 'Paulo', cpf: '04206205086')

      visit root_path
      within 'nav' do
        click_on 'Entrar'
      end
      within 'form#new_user' do
        fill_in 'E-mail', with: 'paulo@leilaodogalpao.com.br'
        fill_in 'Senha', with: '171653'
        click_on 'Entrar'
      end

      within 'nav' do
        expect(page).not_to have_link('Entrar')
        expect(page).to have_button('Sair')
        expect(page).to have_content('Paulo | paulo@leilaodogalpao.com.br')
      end
      expect(page).to have_content('Login efetuado com sucesso.')
    end
  end

  it 'e faz logout' do
    User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '04206205086')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    within 'form#new_user' do
      fill_in 'Senha', with: '171653'
      fill_in 'E-mail', with: 'paulo@email.com'
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
