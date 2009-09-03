CREATE TABLE "game_datas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "game_id" integer, "format" varchar(255), "charset" varchar(255), "source_type" varchar(255), "data" text, "path" varchar(255), "url" varchar(255), "is_commented" boolean, "commented_by" varchar(255), "description" text, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "games" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "game_type" varchar(255) DEFAULT 'weiqi', "status" varchar(255) DEFAULT 'finished', "rule" integer DEFAULT 1, "board_size" integer, "handicap" integer, "first_color" varchar(255) DEFAULT 'black', "komi" float, "result" varchar(255), "winner" varchar(255), "moves" integer, "win_points" float, "name" varchar(255), "event" varchar(255), "place" varchar(255), "source" varchar(255), "played_at" datetime, "is_online_game" boolean, "gaming_platform_id" integer, "description" text, "black_id" integer, "white_id" integer, "black_name" varchar(255), "black_rank" varchar(255), "white_name" varchar(255), "white_rank" varchar(255), "game_data_id" integer, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "gaming_platforms" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nation_region_id" integer, "name" varchar(255), "url" varchar(255), "is_turn_based" boolean, "description" text, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "nation_regions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "description" text, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "online_players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "player_id" integer, "gaming_platform_id" integer, "username" varchar(255), "registered_at" date, "description" text, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "nation_region_id" integer, "username" varchar(255), "last_name" varchar(255), "first_name" varchar(255), "chinese_name" varchar(255), "pinyin_name" varchar(255), "other_names" varchar(255), "is_amateur" boolean, "rank" varchar(255), "sex" varchar(255), "birth_year" integer, "birthday" date, "province_state" varchar(255), "city" varchar(255), "website" varchar(255), "email" varchar(255), "description" text, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "tournament_games" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tournament_id" integer, "game_id" integer, "status" varchar(255), "result" varchar(255), "description" text, "black_id" integer, "white_id" integer, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "tournament_players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tournament_id" integer, "player_id" integer, "is_seed_player" boolean, "passed" boolean, "description" text, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "tournaments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "parent_id" integer, "is_series" boolean, "is_primary" boolean, "name" varchar(255), "organizer" varchar(255), "description" text, "stage" varchar(255), "has_sub_tournaments" boolean, "start_date" date, "end_date" date, "lft" integer, "rgt" integer, "updated_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "uploads" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) NOT NULL, "upload_file_name" varchar(255) NOT NULL, "upload_content_type" varchar(255), "upload_file_size" integer, "upload_updated_at" datetime, "status" varchar(255), "status_detail" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "email" varchar(255), "password_hash" varchar(255), "password_salt" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090228135223');

INSERT INTO schema_migrations (version) VALUES ('20090228140241');

INSERT INTO schema_migrations (version) VALUES ('20090301043245');

INSERT INTO schema_migrations (version) VALUES ('20090301043426');

INSERT INTO schema_migrations (version) VALUES ('20090301044128');

INSERT INTO schema_migrations (version) VALUES ('20090301044630');

INSERT INTO schema_migrations (version) VALUES ('20090301044806');

INSERT INTO schema_migrations (version) VALUES ('20090301045212');

INSERT INTO schema_migrations (version) VALUES ('20090301045403');

INSERT INTO schema_migrations (version) VALUES ('20090707205913');

INSERT INTO schema_migrations (version) VALUES ('20090803144454');