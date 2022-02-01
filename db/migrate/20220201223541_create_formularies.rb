class CreateFormularies < ActiveRecord::Migration[6.1]
  def change
    create_table :formularies do |t|
      t.string :title

      t.timestamps
    end
  end
end
