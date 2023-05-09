require 'rails_helper'

describe 'Usuário se registra' do
  context 'como usuário regular' do
    it 'com sucesso' do
      visit root_path
      click_on 'Entrar'
      click_on 'Criar uma conta'
      fill_in 'Nome', with: 'Márcio'
      fill_in 'E-mail', with: 'pessoa@email.com'
      fill_in 'Senha', with: 'password'
      fill_in 'CPF', with: '48631016004'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar conta'

      expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
      expect(page).to have_content('pessoa@email.com')
      expect(page).to have_button('Sair')
      user = User.last
      expect(user.name).to eq('Márcio')
    end
  end

  context 'como administrador' do
    it 'com sucesso' do
      visit root_path
      click_on 'Entrar'
      click_on 'Criar uma conta'
      fill_in 'Nome', with: 'Márcio'
      fill_in 'E-mail', with: 'marcio@leilaodogalpao.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      fill_in 'CPF', with: '48631016004'
      click_on 'Criar conta'

      expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
      expect(page).to have_content('marcio@leilaodogalpao.com.br')
      expect(page).to have_button('Sair')
      expect(page).to have_button('Painel Admin')
      user = User.last
      expect(user.name).to eq('Márcio')
    end
  end
end
