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

ActiveRecord::Schema.define(version: 20171125182516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.bigint "pre_game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pre_game_id"], name: "index_boards_on_pre_game_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.bigint "pre_game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.integer "money"
    t.index ["player_id"], name: "index_countries_on_player_id"
    t.index ["pre_game_id"], name: "index_countries_on_pre_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pieces", force: :cascade do |t|
    t.boolean "passive", default: false
    t.bigint "country_id"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_pieces_on_country_id"
    t.index ["region_id"], name: "index_pieces_on_region_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "pre_game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "money"
    t.index ["pre_game_id"], name: "index_players_on_pre_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "pre_games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_pre_games_on_game_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.boolean "land", default: true
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_factory", default: false
    t.index ["country_id"], name: "index_regions_on_country_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "countries", "players"
end
