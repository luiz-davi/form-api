class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :nome
      t.belongs_to :formulary, null: false, foreign_key: true
      t.string :tipo_pergunta

      t.timestamps
    end
  end
end
