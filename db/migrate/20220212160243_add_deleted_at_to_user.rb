class AddDeletedAtToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :delted_at
  end
end
