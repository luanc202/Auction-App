require 'rails_helper'

describe 'Usuário com CPF bloqueado' do
  it 'tenta se cadastrar e não tem sucesso' do
    BlockedCpf.create!(cpf: '04206205086')

    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'Nome', with: 'Márcio'
    fill_in 'E-mail', with: 'pessoa@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'CPF', with: '04206205086'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content('CPF está bloqueado')
    expect(current_path).to eq(user_registration_path)
  end

  context 'faz login' do
    it 'vê mensagem de conta suspensa ao  tentar visitar outras páginas' do
      User.create!(email: 'paulo@leilaodogalpao.com.br', password: '171653', name: 'Paulo', cpf: '04206205086')
      BlockedCpf.create!(cpf: '04206205086')

      visit root_path
      within 'nav' do
        click_on 'Entrar'
      end
      within 'form#new_user' do
        fill_in 'E-mail', with: 'paulo@leilaodogalpao.com.br'
        fill_in 'Senha', with: '171653'
        click_on 'Entrar'
      end
      click_on 'Lotes para Leilão'

      expect(page).to have_content('Sua conta está suspensa.')
    end
  end
end
