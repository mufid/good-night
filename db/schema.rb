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

ActiveRecord::Schema[8.0].define(version: 2025_09_06_100934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "sleeps", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "clocked_in_at"
    t.datetime "clocked_out_at"
    t.integer "duration_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.integer "week"
    t.index ["clocked_in_at"], name: "index_sleeps_on_clocked_in_at"
    t.index ["clocked_out_at"], name: "index_sleeps_on_clocked_out_at"
    t.index ["user_id", "clocked_in_at", "duration_minutes"], name: "index_sleeps_on_user_id_and_clocked_in_at_and_duration_minutes"
    t.index ["user_id"], name: "index_sleeps_ensure_single_active_session", unique: true, where: "(clocked_out_at IS NULL)"
    t.index ["user_id"], name: "index_sleeps_on_user_id"
    t.index ["year", "week", "duration_minutes", "user_id"], name: "index_sleeps_on_year_and_week_and_duration_minutes_and_user_id"
  end

  create_table "user_followings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "user_following_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_following_id"], name: "index_user_followings_on_user_following_id"
    t.index ["user_id", "user_following_id"], name: "index_user_followings_on_user_id_and_user_following_id", unique: true
    t.index ["user_id"], name: "index_user_followings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "user_followings", "users", column: "user_following_id"
end
