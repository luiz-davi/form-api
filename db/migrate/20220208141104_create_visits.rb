class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.date :data
      t.string :status
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :checkin_at
      t.datetime :checkout_at

      t.timestamps
    end
  end
end
