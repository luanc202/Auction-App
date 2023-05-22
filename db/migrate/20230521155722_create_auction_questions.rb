class CreateAuctionQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_questions do |t|
      t.string :question
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :auction_batch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
