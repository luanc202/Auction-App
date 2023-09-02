class RenameAuctionBatchesToBatches < ActiveRecord::Migration[7.0]
  def change
    rename_table :auction_batches, :batches
  end
end
