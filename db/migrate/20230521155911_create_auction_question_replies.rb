class CreateAuctionQuestionReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_question_replies do |t|
      t.string :reply
      t.references :user, null: false, foreign_key: true
      t.references :auction_question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
