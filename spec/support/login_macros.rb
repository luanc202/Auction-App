def login(usuario)
  within 'nav' do
    click_on 'Entrar'
  end
  fill_in 'E-mail', with: usuario.email
  fill_in 'Senha', with: usuario.password
  within 'form' do
    click_on 'Entrar'
  end
end
