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

ActiveRecord::Schema[7.1].define(version: 2024_02_27_014248) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "volleyball_set_id", null: false
    t.bigint "player_id"
    t.bigint "incoming_player_id"
    t.bigint "user_id"
    t.bigint "game_id", null: false
    t.bigint "team_id", null: false
    t.integer "quality"
    t.integer "player_rotation"
    t.integer "setter_rotation"
    t.integer "rally_skill"
    t.integer "skill_point"
    t.integer "skill_error"
    t.integer "position"
    t.integer "role"
    t.integer "category"
    t.integer "home_score"
    t.integer "away_score"
    t.boolean "after_timeout"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_events_on_game_id"
    t.index ["incoming_player_id"], name: "index_events_on_incoming_player_id"
    t.index ["player_id"], name: "index_events_on_player_id"
    t.index ["team_id"], name: "index_events_on_team_id"
    t.index ["user_id"], name: "index_events_on_user_id"
    t.index ["volleyball_set_id"], name: "index_events_on_volleyball_set_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "home_team_id", null: false
    t.bigint "away_team_id", null: false
    t.string "title"
    t.string "youtube_link"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tournament_id"
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["tournament_id"], name: "index_games_on_tournament_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "title"
    t.string "website"
    t.bigint "user_id", null: false
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_organizations_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id", null: false
    t.bigint "volleyball_set_id", null: false
    t.bigint "team_id", null: false
    t.integer "status", default: 0
    t.integer "position"
    t.integer "role", default: 0
    t.integer "rotation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "starting_rotation"
    t.boolean "starting_libero"
    t.integer "back_row_position"
    t.integer "front_row_position"
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["team_id"], name: "index_players_on_team_id"
    t.index ["user_id"], name: "index_players_on_user_id"
    t.index ["volleyball_set_id"], name: "index_players_on_volleyball_set_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.string "club"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "head_coach_id"
    t.bigint "assistant_coach_id"
    t.bigint "organization_id"
    t.index ["assistant_coach_id"], name: "index_teams_on_assistant_coach_id"
    t.index ["head_coach_id"], name: "index_teams_on_head_coach_id"
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_tournaments_on_team_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "jersey_number"
    t.bigint "team_id", null: false
    t.integer "position"
    t.integer "role", default: 0
    t.integer "volleyball_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  create_table "volleyball_sets", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "serving_team_id"
    t.bigint "receiving_team_id"
    t.integer "starting_setter_rotation"
    t.integer "setter_rotation"
    t.integer "rotation", default: 1
    t.integer "position"
    t.integer "home_score", default: 0
    t.integer "away_score", default: 0
    t.integer "home_time_outs_left", default: 2
    t.integer "away_time_outs_left", default: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_volleyball_sets_on_game_id"
    t.index ["receiving_team_id"], name: "index_volleyball_sets_on_receiving_team_id"
    t.index ["serving_team_id"], name: "index_volleyball_sets_on_serving_team_id"
  end

  add_foreign_key "events", "games"
  add_foreign_key "events", "players"
  add_foreign_key "events", "players", column: "incoming_player_id"
  add_foreign_key "events", "teams"
  add_foreign_key "events", "users"
  add_foreign_key "events", "volleyball_sets"
  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "games", "tournaments"
  add_foreign_key "organizations", "users"
  add_foreign_key "players", "games"
  add_foreign_key "players", "teams"
  add_foreign_key "players", "users"
  add_foreign_key "players", "volleyball_sets"
  add_foreign_key "teams", "organizations"
  add_foreign_key "teams", "users", column: "assistant_coach_id"
  add_foreign_key "teams", "users", column: "head_coach_id"
  add_foreign_key "tournaments", "teams"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "teams"
  add_foreign_key "volleyball_sets", "games"
  add_foreign_key "volleyball_sets", "teams", column: "receiving_team_id"
  add_foreign_key "volleyball_sets", "teams", column: "serving_team_id"
end
