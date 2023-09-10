class RenameAuctionItemsToItems < ActiveRecord::Migration[7.0]
  def change
    rename_table :auction_items, :items
  end
end
