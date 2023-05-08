class AddCpfToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cpf, :integer, null: false
  end
end
