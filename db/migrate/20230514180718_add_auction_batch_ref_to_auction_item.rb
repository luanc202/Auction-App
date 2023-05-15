class AddAuctionBatchRefToAuctionItem < ActiveRecord::Migration[7.0]
  def change
    add_reference :auction_items, :auction_batch, null: true, foreign_key: true
  end
end
