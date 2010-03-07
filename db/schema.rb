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

ActiveRecord::Schema.define(:version => 20100306212728) do

  create_table "favorites", :force => true do |t|
    t.string   "description"
    t.integer  "user_id",       :null => false
    t.integer  "favorite_type", :null => false
    t.integer  "external_id"
    t.integer  "external_id2"
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["user_id", "favorite_type"], :name => "index_favorites_on_user_id_and_favorite_type"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "game_comments", :force => true do |t|
    t.integer  "game_id"
    t.integer  "move_no"
    t.integer  "commenter_id"
    t.boolean  "by_player"
    t.string   "content",      :limit => 4000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_details", :force => true do |t|
    t.integer  "game_id"
    t.integer  "whose_turn"
    t.datetime "last_move_time"
    t.string   "handicaps"
    t.string   "formatted_moves", :limit => 4000
    t.integer  "first_move_id"
    t.integer  "last_move_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_details", ["game_id"], :name => "game_details_game_id"

  create_table "game_moves", :force => true do |t|
    t.integer  "game_detail_id",  :null => false
    t.integer  "player_id"
    t.integer  "move_no",         :null => false
    t.integer  "color",           :null => false
    t.integer  "x",               :null => false
    t.integer  "y",               :null => false
    t.string   "dead"
    t.boolean  "ko"
    t.integer  "guess_player_id"
    t.datetime "played_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_moves", ["game_detail_id"], :name => "game_moves_detail_id"
  add_index "game_moves", ["guess_player_id"], :name => "game_moves_guess_player_id"
  add_index "game_moves", ["parent_id"], :name => "game_moves_parent_id"

  create_table "games", :force => true do |t|
    t.integer  "game_type"
    t.string   "state",              :default => "finished"
    t.integer  "rule"
    t.string   "rule_raw"
    t.integer  "board_size"
    t.integer  "handicap"
    t.integer  "start_side"
    t.float    "komi"
    t.string   "komi_raw"
    t.string   "result"
    t.integer  "winner"
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
    t.integer  "gaming_platform_id"
    t.text     "description"
    t.integer  "black_id"
    t.integer  "white_id"
    t.string   "black_name"
    t.string   "black_rank"
    t.string   "white_name"
    t.string   "white_rank"
    t.string   "black_team"
    t.string   "white_team"
    t.integer  "primary_upload_id"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "for_rating"
  end

  add_index "games", ["black_id"], :name => "games_black_id"
  add_index "games", ["gaming_platform_id", "black_id", "white_id"], :name => "games_platform_black_white"
  add_index "games", ["gaming_platform_id"], :name => "games_platform_id"
  add_index "games", ["white_id"], :name => "games_white_id"

  create_table "gaming_platforms", :force => true do |t|
    t.integer  "nation_region_id"
    t.string   "name",             :null => false
    t.string   "url"
    t.boolean  "is_turn_based"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_id"
    t.string   "invitees",   :limit => 1024
    t.integer  "game_type"
    t.string   "state"
    t.integer  "rule",                       :default => 1
    t.integer  "handicap",                   :default => 0
    t.integer  "start_side"
    t.float    "komi",                       :default => 7.5
    t.boolean  "for_rating",                 :default => true
    t.string   "note"
    t.string   "response",   :limit => 4000
    t.date     "expires_on"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["invitees"], :name => "invitations_invitees"
  add_index "invitations", ["inviter_id"], :name => "invitations_inviter_id"

  create_table "nation_regions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pair_stats", :force => true do |t|
    t.integer  "player_id",                          :null => false
    t.integer  "opponent_id",                        :null => false
    t.integer  "games_as_black",      :default => 0
    t.integer  "games_won_as_black",  :default => 0
    t.integer  "games_lost_as_black", :default => 0
    t.integer  "games_as_white",      :default => 0
    t.integer  "games_won_as_white",  :default => 0
    t.integer  "games_lost_as_white", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pair_stats", ["opponent_id"], :name => "index_pair_stats_on_opponent_id"
  add_index "pair_stats", ["player_id", "opponent_id"], :name => "index_pair_stats_on_player_id_and_opponent_id", :unique => true
  add_index "pair_stats", ["player_id"], :name => "index_pair_stats_on_player_id"

  create_table "player_stats", :force => true do |t|
    t.integer  "player_id",                          :null => false
    t.integer  "games_as_black",      :default => 0
    t.integer  "games_won_as_black",  :default => 0
    t.integer  "games_lost_as_black", :default => 0
    t.integer  "games_as_white",      :default => 0
    t.integer  "games_won_as_white",  :default => 0
    t.integer  "games_lost_as_white", :default => 0
    t.datetime "first_game_played"
    t.datetime "last_game_played"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_stats", ["player_id"], :name => "index_player_stats_on_player_id", :unique => true

  create_table "players", :force => true do |t|
    t.integer  "nation_region_id"
    t.string   "first_name_en"
    t.string   "last_name_en"
    t.string   "full_name_en"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "other_names"
    t.boolean  "is_amateur"
    t.string   "rank"
    t.string   "sex"
    t.integer  "birth_year"
    t.date     "birthday"
    t.string   "birth_place"
    t.string   "website"
    t.string   "email"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "gaming_platform_id"
    t.integer  "temp_id"
    t.datetime "registered_at"
    t.boolean  "open_for_invitation"
  end

  add_index "players", ["name"], :name => "players_full_name"

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "start_side"
    t.string   "result"
    t.boolean  "multiple"
    t.text     "description"
    t.string   "source"
    t.integer  "upload_id"
    t.integer  "solution_upload_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "description"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_type",   :default => "String"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name"

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
    t.boolean  "is_winner"
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
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "status"
    t.text     "status_detail"
    t.string   "uploader"
    t.integer  "uploader_id"
  end

  add_index "uploads", ["game_id"], :name => "index_uploads_on_game_id"
  add_index "uploads", ["hash_code"], :name => "index_uploads_on_hash_code"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_type",       :default => 0
    t.integer  "external_id"
    t.integer  "role",            :default => 0
    t.integer  "qiren_player_id"
  end

  add_index "users", ["qiren_player_id"], :name => "users_qiren_player_id"
  add_index "users", ["user_type", "external_id"], :name => "index_users_on_user_type_and_external_id"
  add_index "users", ["username"], :name => "index_users_on_username"

end
