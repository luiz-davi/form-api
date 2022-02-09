# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_08_141104) do

  create_table "answers", force: :cascade do |t|
    t.string "content"
    t.integer "formulary_id", null: false
    t.integer "question_id", null: false
    t.string "answered_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["formulary_id"], name: "index_answers_on_formulary_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "formularies", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "nome"
    t.integer "formulary_id", null: false
    t.string "tipo_pergunta"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["formulary_id"], name: "index_questions_on_formulary_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "cpf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  create_table "visits", force: :cascade do |t|
    t.date "data"
    t.string "status"
    t.integer "user_id", null: false
    t.datetime "checkin_at"
    t.datetime "checkout_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "answers", "formularies"
  add_foreign_key "answers", "questions"
  add_foreign_key "questions", "formularies"
  add_foreign_key "visits", "users"
end
