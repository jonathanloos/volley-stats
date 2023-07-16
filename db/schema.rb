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

ActiveRecord::Schema[7.0].define(version: 2023_07_16_192351) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "volleyball_set_id", null: false
    t.bigint "user_id"
    t.bigint "game_id", null: false
    t.bigint "team_id", null: false
    t.integer "rotation"
    t.integer "continuation"
    t.integer "earned"
    t.integer "given"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_events_on_game_id"
    t.index ["team_id"], name: "index_events_on_team_id"
    t.index ["user_id"], name: "index_events_on_user_id"
    t.index ["volleyball_set_id"], name: "index_events_on_volleyball_set_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "title"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_games_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.string "club"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "jersey_number"
    t.bigint "team_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  create_table "volleyball_sets", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "team_id", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_volleyball_sets_on_game_id"
    t.index ["team_id"], name: "index_volleyball_sets_on_team_id"
  end

  add_foreign_key "events", "games"
  add_foreign_key "events", "teams"
  add_foreign_key "events", "users"
  add_foreign_key "events", "volleyball_sets"
  add_foreign_key "games", "teams"
  add_foreign_key "users", "teams"
  add_foreign_key "volleyball_sets", "games"
  add_foreign_key "volleyball_sets", "teams"
end
