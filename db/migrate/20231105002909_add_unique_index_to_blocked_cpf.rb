class AddUniqueIndexToBlockedCpf < ActiveRecord::Migration[7.0]
  def change
    add_index :blocked_cpfs, :cpf, unique: true
  end
end
