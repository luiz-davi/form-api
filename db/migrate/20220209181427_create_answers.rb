class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :content
      t.belongs_to :formulary, null: false, foreign_key: true
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :visit, null: false, foreign_key: true
      t.date :answered_at

      t.timestamps
    end
  end
end
