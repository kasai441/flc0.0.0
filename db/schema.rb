# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_31_134814) do

  create_table "quizcards", force: :cascade do |t|
    t.string "fail_seq"
    t.text "description"
    t.datetime "registered_at"
    t.string "name"
    t.string "connotation"
    t.string "pronunciation"
    t.string "origin"
    t.integer "answer_time"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "appearing_at"
    t.index ["appearing_at"], name: "index_quizcards_on_appearing_at"
    t.index ["user_id"], name: "index_quizcards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.integer "total_time"
    t.integer "practice_days"
    t.datetime "last_practiced_at"
    t.integer "total_practices"
  end

  create_table "waitdays", force: :cascade do |t|
    t.integer "wait_sequence"
    t.integer "wait_day"
    t.integer "quizcard_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quizcard_id", "created_at"], name: "index_waitdays_on_quizcard_id_and_created_at"
    t.index ["quizcard_id"], name: "index_waitdays_on_quizcard_id"
    t.index ["wait_sequence", "quizcard_id"], name: "index_waitdays_on_wait_sequence_and_quizcard_id", unique: true
  end

  add_foreign_key "quizcards", "users"
  add_foreign_key "waitdays", "quizcards"
end
