class CreateAuctionBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_batches do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.integer :minimum_bid_amount
      t.integer :minimum_bid_difference
      t.integer :status, default: 0
      t.integer :approved_by_user_id
      t.integer :created_by_user_id, null: false

      t.timestamps
    end
  end
end
