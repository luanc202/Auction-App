require 'active_support/testing/time_helpers'

include ActiveSupport::Testing::TimeHelpers
extend ActiveSupport::Testing::TimeHelpers

user = User.create!(email: 'julia@leilaodogalpao.com.br', password: '@#$GBRD', name: 'Julia', cpf: '04206205086')
guest_user = User.create!(email: 'paulo@email.com', password: '171653', name: 'Paulo', cpf: '96749196004')

auction_item_category = AuctionItemCategory.create!(name: 'Eletrônicos')
second_auction_item_category = AuctionItemCategory.create!(name: 'Móveis')

travel_to 5.days.ago
batch = Batch.create!(code: 'A4K1L9', start_date: 2.hours.from_now, end_date: 14.days.from_now, minimum_bid_amount: 201,
                      minimum_bid_difference: 10, created_by_user_id: user.id)
batch.approved!
second_batch = Batch.create!(code: '2GWD34', start_date: 4.hours.from_now, end_date: 12.days.from_now, minimum_bid_amount: 505,
                             minimum_bid_difference: 10, created_by_user_id: user.id)
second_batch.approved!
third_batch = Batch.create!(code: 'J3EQ97', start_date: 6.hours.from_now, end_date: 15.days.from_now, minimum_bid_amount: 700,
                            minimum_bid_difference: 10, created_by_user_id: user.id)
travel_back

auction_item = Item.create!(name: 'TV Samsung 32', description: 'Samsung Smart TV 32 polegadas HDR LED 4K', weight: 10_000, width: 50,
                            height: 70, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: batch.id)
auction_item.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                          content_type: 'image/png')
auction_item_3 = Item.create!(name: 'Mesa de Escritório', description: 'Mesa de escritório em MDF e pernas de aço', weight: 40_000, width: 100,
                              height: 60, depth: 50, auction_item_category_id: second_auction_item_category.id, batch_id: third_batch.id)
auction_item_3.image.attach(io: File.open('spec/fixtures/desk.jpg'), filename: 'desk.jpg',
                            content_type: 'image/jpg')
auction_item_2 = Item.create!(name: 'TV Philips 32', description: 'Philips Smart TV 32 polegadas LCD 2K', weight: 8_000, width: 40,
                              height: 50, depth: 10, auction_item_category_id: auction_item_category.id, batch_id: second_batch.id)
auction_item_2.image.attach(io: File.open('spec/fixtures/tv-imagem.png'), filename: 'tv-imagem.png',
                            content_type: 'image/png')

Bid.create!(batch_id: batch.id, user_id: guest_user.id, value: 220)

batch.auction_questions.create!(user: guest_user, question: 'Algum dos itens está danificado ou aberto?')
batch.auction_questions.create!(user: guest_user, question: 'É possível fazer retirada?')
second_batch.auction_questions.create!(user: guest_user,
                                       question: 'São apenas itens eletrônicos?')

AuctionQuestionReply.create!(user:, auction_question: batch.auction_questions.first,
                             reply: 'Não, todos lacrados e intactos. Em caso de danos ou lacre violado, o comprador poderá devolver o item e receber o dinheiro de volta.')

UserFavBatch.create!(user: guest_user, batch:)

BlockedCpf.create!(cpf: '49914857035')
BlockedCpf.create!(cpf: '00742158098')
