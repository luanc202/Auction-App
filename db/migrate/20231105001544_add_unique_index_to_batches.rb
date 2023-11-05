class AddUniqueIndexToBatches < ActiveRecord::Migration[7.0]
  def change
    add_index :batches, :code, unique: true
  end
end
