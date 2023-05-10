class CreateAuctionItemCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :auction_item_categories do |t|
      t.string :category

      t.timestamps
    end
  end
end
