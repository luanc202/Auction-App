# Projeto de Leilão de Estoque para o Treinadev 10

Esta aplicação Ruby on Rails é uma aplicação web desenvolvida, ela fornece uma maneira simples de gerenciar e lotes de leilão, seus itens, perguntas, imagens, lances e gerenciar usuários.

## Instalação e configuração

Para começar a trabalhar com esta aplicação, siga estas etapas:

1. Instale o Ruby: Certifique-se de que você tenha o Ruby instalado em seu computador. Você pode verificar isso executando `ruby -v`. Se você não tiver o Ruby, você pode seguir ~[os guias de aprendizado do Ruby](https://guides.rubyonrails.org/getting_started.html)~.

2. Instale o Rails: Se ainda não instalou o Rails, siga o ~[guia de instalação oficial do Rails](https://guides.rubyonrails.org/getting_started.html)~.

## Requisitos e versões
* Ruby version: 3.2.1

* System dependencies: 
  - libvips 8.14.2-1 
  - openslide 3.4.1-4 

## Configurações

 Clone o projeto com `git clone` e rode o comando `bundle install` dentro do diretório par onde clonou para instalar as dependências.
 
 Como foi utilizado SQLite3, não é necessário configurar o banco de dados, basta rodar o comando `rails db:migrate` para criar as tabelas e `rails db:seed` para popular o banco de dados com dados de teste.

 Em seguida, rode o comando `rails server` para iniciar o servidor e acesse `http://localhost:3000` para acessar a aplicação.

## Rodando testes

Para rodar os testes, basta rodar o comando `rspec` dentro do diretório do projeto.

## Tarefas realizadas

- [x] Usuários Administradores
- [x] Cadastro de Itens para Leilão
- [x] Configuração de Lotes
- [x] Visualizar Lotes
- [x] Fazendo Lances
- [x] Validando Resultados
- [x] Verificando Lotes Vencidos
- [x] Bônus - Lotes Favoritos
- [x] Bônus - Dúvidas sobre um lote
- [x] Bônus - Bloqueio de CPFs
- [x] Bônus - Busca de Lotes e Itens

## Tarefas pendentes

- [ ] Extra - Testes de Request
## Imagem do esquema do banco de dados

![image](database-schema.png)