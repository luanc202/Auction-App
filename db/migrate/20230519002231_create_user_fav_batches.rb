class CreateUserFavBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :user_fav_batches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :auction_batch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
