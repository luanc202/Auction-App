class RenameBatchesForeignKeyInTables < ActiveRecord::Migration[7.0]
  def change
    rename_column :bids, :auction_batch_id, :batch_id
    rename_column :auction_items, :auction_batch_id, :batch_id
    rename_column :auction_questions, :auction_batch_id, :batch_id
    rename_column :user_fav_batches, :auction_batch_id, :batch_id
    rename_column :won_auction_batches, :auction_batch_id, :batch_id
  end
end
