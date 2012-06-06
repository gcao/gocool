# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120601154132) do

  create_table "cg_game_comments", :force => true do |t|
    t.integer  "game_id"
    t.integer  "move_no"
    t.integer  "commenter_id"
    t.boolean  "by_player"
    t.string   "content",      :limit => 4000
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "cg_game_details", :force => true do |t|
    t.integer  "game_id"
    t.integer  "whose_turn"
    t.datetime "last_move_time"
    t.text     "formatted_moves"
    t.integer  "first_move_id"
    t.integer  "last_move_id"
    t.string   "setup_points"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "cg_game_details", ["game_id"], :name => "game_details_game_id"

  create_table "cg_game_moves", :force => true do |t|
    t.integer  "game_detail_id",   :null => false
    t.integer  "player_id"
    t.integer  "move_no",          :null => false
    t.integer  "color",            :null => false
    t.integer  "x",                :null => false
    t.integer  "y",                :null => false
    t.string   "dead"
    t.integer  "guess_player_id"
    t.datetime "played_at"
    t.integer  "parent_id"
    t.string   "setup_points"
    t.text     "serialized_board"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "cg_game_moves", ["game_detail_id"], :name => "game_moves_detail_id"
  add_index "cg_game_moves", ["guess_player_id"], :name => "game_moves_guess_player_id"
  add_index "cg_game_moves", ["parent_id"], :name => "game_moves_parent_id"

  create_table "cg_games", :force => true do |t|
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
    t.boolean  "is_online_game"
    t.integer  "gaming_platform_id"
    t.text     "description"
    t.boolean  "for_rating"
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
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "cg_games", ["black_id"], :name => "games_black_id"
  add_index "cg_games", ["gaming_platform_id", "black_id", "white_id"], :name => "games_platform_black_white"
  add_index "cg_games", ["gaming_platform_id"], :name => "games_platform_id"
  add_index "cg_games", ["white_id"], :name => "games_white_id"

  create_table "cg_gaming_platforms", :force => true do |t|
    t.integer  "nation_region_id"
    t.string   "name",             :null => false
    t.string   "url"
    t.boolean  "is_turn_based"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "cg_invitations", :force => true do |t|
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
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "cg_invitations", ["invitees"], :name => "invitations_invitees", :length => {"invitees"=>255}
  add_index "cg_invitations", ["inviter_id"], :name => "invitations_inviter_id"

  create_table "cg_messages", :force => true do |t|
    t.integer  "source_type",   :null => false
    t.integer  "source_id"
    t.string   "source"
    t.integer  "receiver_type", :null => false
    t.integer  "receiver_id"
    t.string   "message_type",  :null => false
    t.string   "level"
    t.string   "visibility"
    t.text     "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "cg_messages", ["receiver_type", "receiver_id"], :name => "messages_receiver"

  create_table "cg_nation_regions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cg_pair_stats", :force => true do |t|
    t.integer  "player_id",                          :null => false
    t.integer  "opponent_id",                        :null => false
    t.integer  "games_as_black",      :default => 0
    t.integer  "games_won_as_black",  :default => 0
    t.integer  "games_lost_as_black", :default => 0
    t.integer  "games_as_white",      :default => 0
    t.integer  "games_won_as_white",  :default => 0
    t.integer  "games_lost_as_white", :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "cg_pair_stats", ["opponent_id"], :name => "index_cg_pair_stats_on_opponent_id"
  add_index "cg_pair_stats", ["player_id", "opponent_id"], :name => "index_cg_pair_stats_on_player_id_and_opponent_id", :unique => true
  add_index "cg_pair_stats", ["player_id"], :name => "index_cg_pair_stats_on_player_id"

  create_table "cg_player_stats", :force => true do |t|
    t.integer  "player_id",                          :null => false
    t.integer  "games_as_black",      :default => 0
    t.integer  "games_won_as_black",  :default => 0
    t.integer  "games_lost_as_black", :default => 0
    t.integer  "games_as_white",      :default => 0
    t.integer  "games_won_as_white",  :default => 0
    t.integer  "games_lost_as_white", :default => 0
    t.datetime "first_game_played"
    t.datetime "last_game_played"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "cg_player_stats", ["player_id"], :name => "index_cg_player_stats_on_player_id", :unique => true

  create_table "cg_players", :force => true do |t|
    t.integer  "nation_region_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.boolean  "is_amateur"
    t.string   "rank"
    t.string   "sex"
    t.integer  "birth_year"
    t.date     "birthday"
    t.string   "birth_place"
    t.string   "website"
    t.string   "email"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "gaming_platform_id"
    t.datetime "registered_at"
    t.string   "updated_by"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "cg_players", ["name"], :name => "cg_players_name"

  create_table "cg_uploads", :force => true do |t|
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
    t.string   "file_file_name"
    t.binary   "file_content"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "status"
    t.text     "status_detail"
    t.string   "uploader"
    t.integer  "uploader_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "cg_uploads", ["game_id"], :name => "index_cg_uploads_on_game_id"
  add_index "cg_uploads", ["hash_code"], :name => "index_cg_uploads_on_hash_code"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
