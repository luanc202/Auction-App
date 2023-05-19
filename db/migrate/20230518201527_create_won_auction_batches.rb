class CreateWonAuctionBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :won_auction_batches do |t|
      t.references :auction_batch, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
