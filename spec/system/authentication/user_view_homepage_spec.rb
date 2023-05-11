require 'rails_helper'

describe 'usuário visita tela inicial' do
  it 'e vê o nome do app' do
    visit(root_path)

    expect(page).to have_content('Leilões de Estoque')
    expect(page).to have_link('Leilões de Estoque', href: root_path)
  end
end
