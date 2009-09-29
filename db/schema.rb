# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090803144454) do

  create_table "game_sources", :force => true do |t|
    t.integer  "game_id"
    t.string   "format"
    t.string   "charset"
    t.string   "source_type"
    t.string   "source"
    t.text     "data"
    t.integer  "upload_id"
    t.boolean  "is_commented"
    t.string   "commented_by"
    t.text     "description"
    t.string   "hash_code"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_sources", ["game_id"], :name => "index_game_sources_on_game_id"
  add_index "game_sources", ["hash_code"], :name => "index_game_sources_on_hash_code"

  create_table "games", :force => true do |t|
    t.integer  "game_type"
    t.string   "status",                 :default => "finished"
    t.integer  "rule"
    t.string   "rule_raw"
    t.integer  "board_size"
    t.integer  "handicap"
    t.integer  "start_color"
    t.float    "komi"
    t.string   "komi_raw"
    t.string   "result"
    t.integer  "winner"
    t.string   "winner_raw"
    t.integer  "moves"
    t.float    "win_points"
    t.string   "name"
    t.string   "event"
    t.string   "place"
    t.string   "source"
    t.string   "program"
    t.datetime "played_at"
    t.string   "played_at_raw"
    t.string   "time_rule"
    t.boolean  "is_online_game"
    t.integer  "gaming_platform_id"
    t.text     "description"
    t.integer  "black_id"
    t.integer  "white_id"
    t.string   "black_name"
    t.string   "black_rank"
    t.string   "white_name"
    t.string   "white_rank"
    t.integer  "primary_game_source_id"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gaming_platforms", :force => true do |t|
    t.integer  "nation_region_id"
    t.string   "name"
    t.string   "url"
    t.boolean  "is_turn_based"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nation_regions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_players", :force => true do |t|
    t.integer  "player_id"
    t.integer  "gaming_platform_id"
    t.string   "username"
    t.date     "registered_at"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "nation_region_id"
    t.string   "username"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "chinese_name"
    t.string   "pinyin_name"
    t.string   "other_names"
    t.boolean  "is_amateur"
    t.string   "rank"
    t.string   "sex"
    t.integer  "birth_year"
    t.date     "birthday"
    t.string   "province_state"
    t.string   "city"
    t.string   "website"
    t.string   "email"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_games", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "game_id"
    t.string   "status"
    t.string   "result"
    t.text     "description"
    t.integer  "black_id"
    t.integer  "white_id"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournament_players", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "player_id"
    t.boolean  "is_seed_player"
    t.boolean  "passed"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.integer  "parent_id"
    t.boolean  "is_series"
    t.boolean  "is_primary"
    t.string   "name"
    t.string   "organizer"
    t.text     "description"
    t.string   "stage"
    t.boolean  "has_sub_tournaments"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.string   "upload_file_name",    :null => false
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.string   "status"
    t.text     "status_detail"
    t.string   "email"
    t.string   "hash_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["hash_code"], :name => "index_uploads_on_hash_code"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
