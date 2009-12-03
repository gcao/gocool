DELIMITER $$
DROP PROCEDURE IF EXISTS test $$
CREATE PROCEDURE test()
BEGIN
  DECLARE black_id, white_id, winner, end_of_cursor INT DEFAULT 0;
  DECLARE game_cursor CURSOR FOR
    SELECT winner, black_id, white_id FROM games WHERE gaming_platform_id > 0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET end_of_cursor = 1;

  UPDATE online_player_stats SET games_as_black = 0, games_won_as_black = 0, games_lost_as_black = 0,
    games_as_white = 0, games_won_as_white = 0, games_lost_as_white = 0;

  OPEN game_cursor;
  FETCH game_cursor INTO winner, black_id, white_id;
  REPEAT
    IF winner > 0 THEN
      CALL increment_online_player_stats(black_id, white_id, winner);
    END IF;

    FETCH game_cursor INTO winner, black_id, white_id;
    UNTIL end_of_cursor = 1
  END REPEAT;
  CLOSE game_cursor;
END;
$$
DELIMITER ;
