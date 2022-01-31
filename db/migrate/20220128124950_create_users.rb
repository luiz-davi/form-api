class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :nome
      t.string :email
      t.string :cpf

      t.timestamps
    end
  end
end
