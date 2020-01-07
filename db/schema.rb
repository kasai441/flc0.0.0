# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191230083927) do

  create_table "quizcards", force: :cascade do |t|
    t.string "fail_seq"
    t.text "description"
    t.datetime "registered_at"
    t.string "name"
    t.string "connotation"
    t.string "pronunciation"
    t.string "origin"
    t.integer "wait_seconds"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "appearing_at"
    t.float "beta"
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
  end

  create_table "waitdays", force: :cascade do |t|
    t.integer "wait_sequence"
    t.integer "wait_day"
    t.integer "quizcard_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quizcard_id", "created_at"], name: "index_waitdays_on_quizcard_id_and_created_at"
    t.index ["quizcard_id"], name: "index_waitdays_on_quizcard_id"
  end

end
