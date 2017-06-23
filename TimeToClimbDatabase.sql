-- *************************************************************
-- Creates the database "lol" for Time2Climb.gg
-- Created By: Nick Akhmetov and Richard Tu
-- *************************************************************

-- ********************************************
-- CREATE THE LOL DATABASE
-- *******************************************

-- create the database
DROP DATABASE IF EXISTS lol;
CREATE DATABASE lol;

-- select the database
USE lol;

-- create the tables
DROP TABLE IF EXISTS summoners;
CREATE TABLE summoners
(
	summoner_id    BIGINT		PRIMARY KEY,
	account_id     BIGINT       NOT NULL,
	summoner_name  VARCHAR(100) NOT NULL,
	summoner_level INT          NOT NULL,
    CONSTRAINT U_summoner_name UNIQUE (summoner_name)
);

DROP TABLE IF EXISTS leagues;
CREATE TABLE leagues
(
  league_season INT          NOT NULL,
  league_rank   VARCHAR(100) NOT NULL,
  summoner_id   BIGINT,
  PRIMARY KEY (league_season, summoner_id),
	CONSTRAINT summoners_fk_leagues
	FOREIGN KEY (summoner_id)
	REFERENCES summoners (summoner_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS champions;
CREATE TABLE champions
(
	champion_id   INT 			PRIMARY KEY,
	champion_name VARCHAR(100) 	NOT NULL,
	champion_type VARCHAR(100) 	NOT NULL
);

DROP TABLE IF EXISTS matches;
CREATE TABLE matches
(
	match_id      BIGINT 		PRIMARY KEY,
	match_season  INT          	NOT NULL,
	match_lane    VARCHAR(100) 	NOT NULL,
	match_win     BOOLEAN      	NOT NULL,
	match_kills   INT          	NOT NULL,
	match_deaths  INT          	NOT NULL,
	match_assists INT          	NOT NULL,
	match_cs      INT          	NOT NULL,
	champion_id   INT,
	summoner_id   BIGINT,
	CONSTRAINT champions_fk_matches
	FOREIGN KEY (champion_id)
	REFERENCES champions (champion_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	CONSTRAINT summoners_fk_matches
	FOREIGN KEY (summoner_id)
	REFERENCES summoners (summoner_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS nick_history;
CREATE TABLE nick_history
(
  match_id      BIGINT PRIMARY KEY,
  match_season  INT          NOT NULL,
  match_lane    VARCHAR(100) NOT NULL,
  match_win     BOOLEAN      NOT NULL,
  match_kills   INT          NOT NULL,
  match_deaths  INT          NOT NULL,
  match_assists INT          NOT NULL,
  match_cs      INT          NOT NULL,
  champion_id   INT,
  summoner_id   BIGINT,
  CONSTRAINT champions_fk_nick_history
  FOREIGN KEY (champion_id)
  REFERENCES champions (champion_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT summoners_fk_nick_history
  FOREIGN KEY (summoner_id)
  REFERENCES summoners (summoner_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS richard_history;
CREATE TABLE richard_history
(
  match_id      BIGINT PRIMARY KEY,
  match_season  INT          NOT NULL,
  match_lane    VARCHAR(100) NOT NULL,
  match_win     BOOLEAN      NOT NULL,
  match_kills   INT          NOT NULL,
  match_deaths  INT          NOT NULL,
  match_assists INT          NOT NULL,
  match_cs      INT          NOT NULL,
  champion_id   INT,
  summoner_id   BIGINT,
  CONSTRAINT champions_fk_richard_history
  FOREIGN KEY (champion_id)
  REFERENCES champions (champion_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT summoners_fk_richard_history
  FOREIGN KEY (summoner_id)
  REFERENCES summoners (summoner_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- PREFERENCES TABLE
DROP TABLE IF EXISTS active_summoner;
CREATE TABLE active_summoner
(
  summoner_name VARCHAR(100) NOT NULL,
  summoner_id   BIGINT PRIMARY KEY,
  active        BOOLEAN      NOT NULL,
  CONSTRAINT active_fk_summoner_id
  FOREIGN KEY (summoner_id)
  REFERENCES summoners (summoner_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE,

  CONSTRAINT active_fk_summoner_name
  FOREIGN KEY (summoner_name)
  REFERENCES summoners (summoner_name)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

INSERT INTO summoners VALUES
  (123456789, 111111111, "Richard", 30),
  (234567890, 222222222, "Nick", 30);

INSERT INTO active_summoner VALUES
  ("Richard", 123456789, FALSE),
  ("Nick", 234567890, FALSE);


INSERT INTO leagues VALUES
  (2, "Gold 3", 123456789),
  (3, "Gold 1", 123456789),
  (4, "Platinum 5", 123456789),
  (5, "Gold 1", 123456789),
  (7, "Gold 4", 123456789),
  (3, "Silver 1", 234567890),
  (4, "Gold 1", 234567890),
  (5, "Platinum 1", 234567890),
  (6, "Diamond 1", 234567890),
  (7, "Master", 234567890);
  

INSERT INTO champions VALUES
  (24, "Jax", "fighter"),
  (62, "Wukong", "fighter"),
  (35, "Shaco", "assassin"),
  (19, "Warwick", "fighter"),
  (498, "Xayah", "marksman"),
  (76, "Nidalee", "assassin"),
  (143, "Zyra", "mage"),
  (240, "Kled", "fighter"),
  (63, "Brand", "mage"),
  (33, "Rammus", "tank"),
  (420, "Illaoi", "fighter"),
  (42, "Corki", "marksman"),
  (201, "Braum", "tank"),
  (122, "Darius", "juggernaut"),
  (23, "Tryndamere", "fighter"),
  (21, "Miss Fortune", "marksman"),
  (83, "Yorick", "juggernaut"),
  (101, "Xerath", "mage"),
  (15, "Sivir", "marksman"),
  (92, "Riven", "fighter"),
  (61, "Orianna", "mage"),
  (41, "Gangplank", "fighter"),
  (54, "Malphite", "tank"),
  (78, "Poppy", "tank"),
  (30, "Karthus", "mage"),
  (126, "Jayce", "fighter"),
  (20, "Nunu", "tank"),
  (48, "Trundle", "fighter"),
  (104, "Graves", "marksman"),
  (25, "Morgana", "mage");

INSERT INTO richard_history VALUES
  (1, 5, "top", TRUE, 4, 5, 8, 120, 24, 123456789), -- Jax KDA: 8/13/20, 50% winrate (#2)
  (2, 5, "top", FALSE, 4, 6, 12, 183, 24, 123456789),
  (3, 5, "top", FALSE, 4, 2, 4, 84, 126, 123456789), -- Jayce KDA: 4/2/4, 0% winrate (#3)
  (4, 5, "top", TRUE, 10, 3, 7, 230, 41, 123456789), -- Gangplank KDA: 33/9/21, 67% winrate (#1)
  (5, 5, "top", FALSE, 11, 3, 7, 230, 41, 123456789),
  (6, 5, "top", TRUE, 12, 3, 7, 230, 41, 123456789),

  (7, 5, "mid", TRUE, 4, 5, 8, 120, 61, 123456789), -- Orianna KDA: 4/5/8, 100% winrate (#2)
  (8, 5, "mid", FALSE, 4, 6, 12, 183, 30, 123456789), -- Karthus KDA: 8/8/16, 0% winrate (#3)
  (9, 5, "mid", FALSE, 4, 2, 4, 84, 30, 123456789),
  (10, 5, "mid", TRUE, 10, 3, 7, 230, 101, 123456789), -- Xerath KDA: 30/9/21, 67% winrate (#1)
  (11, 5, "mid", FALSE, 10, 3, 7, 230, 101, 123456789),
  (12, 5, "mid", TRUE, 10, 3, 7, 230, 101, 123456789),

  (13, 5, "adc", TRUE, 4, 5, 8, 120, 15, 123456789), -- Sivir KDA: 12/13/24, 33% winrate (#3)
  (14, 5, "adc", FALSE, 4, 6, 12, 183, 15, 123456789),
  (15, 5, "adc", FALSE, 4, 2, 4, 84, 15, 123456789),
  (16, 5, "adc", TRUE, 10, 3, 7, 230, 498, 123456789), -- Xayah KDA: 20/6/14, 50% winrate (#2)
  (17, 5, "adc", FALSE, 10, 3, 7, 230, 498, 123456789),
  (18, 5, "adc", TRUE, 10, 3, 7, 230, 104, 123456789), -- Graves KDA: 10/3/7, 100% winrate (#1)

  (19, 5, "sup", FALSE, 10, 5, 8, 120, 25, 123456789), -- Morgana KDA: 20/11/20, 0% winrate (#3)
  (20, 5, "sup", FALSE, 10, 6, 12, 183, 25, 123456789),
  (21, 5, "sup", TRUE, 10, 2, 10, 84, 201, 123456789), -- Braum KDA: 10/2/10, 100% winrate (#1)
  (22, 5, "sup", TRUE, 10, 3, 7, 230, 63, 123456789), -- Brand KDA: 30/9/21, 33% winrate (#2)
  (23, 5, "sup", FALSE, 10, 3, 7, 230, 63, 123456789),
  (24, 5, "sup", FALSE, 10, 3, 7, 230, 63, 123456789),

  (25, 5, "jng", TRUE, 10, 5, 8, 120, 62, 123456789), -- Wukong KDA: 20/11/20, 50% winrate (#2)
  (26, 5, "jng", FALSE, 10, 6, 12, 183, 62, 123456789),
  (27, 5, "jng", FALSE, 10, 2, 10, 84, 35, 123456789), -- Shaco KDA: 10/2/10, 0% winrate (#3)
  (28, 5, "jng", TRUE, 10, 3, 7, 230, 19, 123456789), -- Warwick KDA: 30/9/21, 33% winrate (#1)
  (29, 5, "jng", FALSE, 10, 3, 7, 230, 19, 123456789),
  (30, 5, "jng", FALSE, 10, 3, 7, 230, 19, 123456789);

INSERT INTO nick_history VALUES
  (31, 5, "top", TRUE, 4, 5, 8, 120, 24, 234567890), -- Jax KDA: 8/13/20, 50% winrate (#3)
  (32, 5, "top", FALSE, 4, 6, 12, 183, 24, 234567890),
  (33, 5, "top", TRUE, 4, 2, 4, 84, 126, 234567890), -- Jayce KDA: 4/2/4, 100% winrate (#1)
  (34, 5, "top", TRUE, 10, 3, 7, 230, 41, 234567890), -- Gangplank KDA: 33/9/21, 33% winrate (#2)
  (35, 5, "top", FALSE, 11, 3, 7, 230, 41, 234567890),
  (36, 5, "top", FALSE, 12, 3, 7, 230, 41, 234567890),

  (37, 5, "mid", TRUE, 0, 5, 0, 120, 61, 234567890), -- Orianna KDA: 0/5/0, 100% winrate (#3)
  (38, 5, "mid", TRUE, 4, 6, 12, 183, 30, 234567890), -- Karthus KDA: 18/8/16, 50% winrate (#3)
  (39, 5, "mid", TRUE, 14, 2, 4, 84, 30, 234567890),
  (40, 5, "mid", FALSE, 10, 3, 7, 230, 101, 234567890), -- Xerath KDA: 30/9/21, 33% winrate (#1)
  (41, 5, "mid", FALSE, 10, 3, 7, 230, 101, 234567890),
  (42, 5, "mid", TRUE, 10, 3, 7, 230, 101, 234567890),

  (43, 5, "adc", TRUE, 4, 5, 8, 120, 15, 234567890), -- Sivir KDA: 12/13/24, 100% winrate (#2)
  (44, 5, "adc", TRUE, 4, 6, 12, 183, 15, 234567890),
  (45, 5, "adc", TRUE, 4, 2, 4, 84, 15, 234567890),
  (46, 5, "adc", TRUE, 10, 3, 7, 230, 498, 234567890), -- Xayah KDA: 20/6/14, 50% winrate (#1)
  (47, 5, "adc", FALSE, 10, 3, 7, 230, 498, 234567890),
  (48, 5, "adc", TRUE, 10, 3, 7, 230, 104, 234567890), -- Graves KDA: 10/3/7, 0% winrate (#3)

  (49, 5, "sup", TRUE, 21, 2, 8, 120, 25, 234567890), -- Morgana KDA: 31/5/20, 50% winrate (#1)
  (50, 5, "sup", FALSE, 10, 3, 12, 183, 25, 234567890),
  (51, 5, "sup", TRUE, 10, 2, 10, 84, 201, 234567890), -- Braum KDA: 10/2/10, 100% winrate (#2)
  (52, 5, "sup", FALSE, 10, 3, 7, 230, 63, 234567890), -- Brand KDA: 30/9/21, 0% winrate (#3)
  (53, 5, "sup", FALSE, 10, 3, 7, 230, 63, 234567890),
  (54, 5, "sup", FALSE, 10, 3, 7, 230, 63, 234567890),

  (55, 5, "jng", TRUE, 10, 5, 8, 120, 62, 234567890), -- Wukong KDA: 20/11/20, 100% winrate (#1)
  (56, 5, "jng", TRUE, 10, 6, 12, 183, 62, 234567890),
  (57, 5, "jng", FALSE, 10, 2, 10, 84, 35, 234567890), -- Shaco KDA: 10/2/10, 0% winrate (#3)
  (58, 5, "jng", TRUE, 10, 3, 7, 230, 19, 234567890), -- Warwick KDA: 30/9/21, 33% winrate (#2)
  (59, 5, "jng", FALSE, 10, 3, 7, 230, 19, 234567890),
  (60, 5, "jng", FALSE, 10, 3, 7, 230, 19, 234567890);


-- Function for activate_summoner --
DROP FUNCTION IF EXISTS active;
DELIMITER $$
CREATE FUNCTION
active(
	sum_id BIGINT
) RETURNS BOOLEAN
BEGIN
 DECLARE flag BOOLEAN;
 SELECT active INTO flag FROM active_summoner AS a WHERE sum_id = a.summoner_id;
 RETURN flag;
END$$
DELIMITER ;


-- SET ACTIVE SUMMONERS --
DROP TRIGGER IF EXISTS activate_summoner;
DELIMITER $$
CREATE TRIGGER activate_summoner
AFTER UPDATE ON active_summoner
FOR EACH ROW
  BEGIN
    DELETE FROM matches;
    IF
    active(123456789)
    THEN
      INSERT INTO matches SELECT *
                          FROM richard_history;
    END IF;
    IF
    active(234567890)
    THEN
      INSERT INTO matches SELECT * FROM nick_history;
    END IF;
  END $$
DELIMITER ;


-- Procedures --
-- retrieve_summoner --
-- Gets the summoner's information to be used in future queries (level and ids)
DROP PROCEDURE IF EXISTS retrieve_summoner;
DELIMITER $$
CREATE PROCEDURE
	retrieve_summoner(
	IN sum_name VARCHAR(100)
)
	BEGIN
		SELECT
			summoner_name,
			summoner_level,
			summoner_id,
			account_id
		FROM summoners s
		WHERE s.summoner_name = sum_name;
	END$$
DELIMITER ;

-- CALL retrieve_summoner('Richard');
-- CALL retrieve_summoner('Nick');

-- retrieve_leagues --
-- Gets the summoner's rank history --
DROP PROCEDURE IF EXISTS retrieve_leagues;
DELIMITER $$
CREATE PROCEDURE
	retrieve_leagues(
	IN sum_id BIGINT
)
	BEGIN
		SELECT
			summoner_name,
			league_season,
			league_rank
		FROM summoners s, leagues l
		WHERE s.summoner_id = sum_id
		ORDER BY summoner_name;
	END$$
DELIMITER ;

-- CALL retrieve_leagues(123456789);
-- CALL retrieve_leagues(234567890);


-- top_three_top --
-- Gets the top 3 champions the summoner played in top lane
DROP PROCEDURE IF EXISTS top_three_top;
DELIMITER $$
CREATE PROCEDURE
	top_three_top(IN sum_id BIGINT)
	BEGIN
		SELECT
      champion_name,
      kda,
      winrate,
      performance,
      STDDEV(winrate) * STDDEV(performance) +
      STDDEV(winrate) * (performance * performance) +
      STDDEV(performance) * (winrate * winrate) AS standard_deviation
    FROM (
           SELECT
             champion_name,
             kda,
             winrate,
             kda * winrate AS performance
           FROM (
                  SELECT
                    champions.champion_name                                                             AS champion_name,
                    (SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths) AS kda,
                    count(matches.match_win)                                                            AS games_played,
                    count(CASE WHEN matches.match_win
                      THEN 1 END) / count(matches.match_win)                                            AS winrate
                  FROM matches
                    INNER JOIN champions ON matches.champion_id = champions.champion_id
                  WHERE match_lane = 'TOP' AND matches.summoner_id = sum_id
                  GROUP BY champion_name
                ) AS calculations
         ) AS performance_calculation
    GROUP BY champion_name
    ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;


-- top_three_jng --
-- Gets the top 3 champions the summoner played in the jungle
DROP PROCEDURE IF EXISTS top_three_jng;
DELIMITER $$
CREATE PROCEDURE
	top_three_jng(
	IN sum_id BIGINT
)
	BEGIN
		SELECT
      champion_name,
      kda,
      winrate,
      performance,
      STDDEV(winrate) * STDDEV(performance) +
      STDDEV(winrate) * (performance * performance) +
      STDDEV(performance) * (winrate * winrate) AS standard_deviation
    FROM (
           SELECT
             champion_name,
             kda,
             winrate,
             kda * winrate AS performance
           FROM (
                  SELECT
                    champions.champion_name                                                             AS champion_name,
                    (SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths) AS kda,
                    count(matches.match_win)                                                            AS games_played,
                    count(CASE WHEN matches.match_win
                      THEN 1 END) / count(matches.match_win)                                            AS winrate
                  FROM matches
                    INNER JOIN champions ON matches.champion_id = champions.champion_id
                  WHERE match_lane = 'JNG' AND matches.summoner_id = sum_id
                  GROUP BY champion_name
                ) AS calculations
         ) AS performance_calculation
    GROUP BY champion_name
    ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;


-- top_three_mid --
-- Gets the top 3 champions the summoner played in the mid lane
DROP PROCEDURE IF EXISTS top_three_mid;
DELIMITER $$
CREATE PROCEDURE
	top_three_mid(
	IN sum_id BIGINT
)
	BEGIN
		SELECT
      champion_name,
      kda,
      winrate,
      performance,
      STDDEV(winrate) * STDDEV(performance) +
      STDDEV(winrate) * (performance * performance) +
      STDDEV(performance) * (winrate * winrate) AS standard_deviation
    FROM (
           SELECT
             champion_name,
             kda,
             winrate,
             kda * winrate AS performance
           FROM (
                  SELECT
                    champions.champion_name                                                             AS champion_name,
                    (SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths) AS kda,
                    count(matches.match_win)                                                            AS games_played,
                    count(CASE WHEN matches.match_win
                      THEN 1 END) / count(matches.match_win)                                            AS winrate
                  FROM matches
                    INNER JOIN champions ON matches.champion_id = champions.champion_id
                  WHERE match_lane = 'MID' AND matches.summoner_id = sum_id
                  GROUP BY champion_name
                ) AS calculations
         ) AS performance_calculation
    GROUP BY champion_name
    ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;


-- top_three_adc --
-- Gets the top 3 champions the summoner played in the bottom lane as adc
DROP PROCEDURE IF EXISTS top_three_adc;
DELIMITER $$
CREATE PROCEDURE
	top_three_adc(
	IN sum_id BIGINT
)
	BEGIN
		SELECT
      champion_name,
      kda,
      winrate,
      performance,
      STDDEV(winrate) * STDDEV(performance) +
      STDDEV(winrate) * (performance * performance) +
      STDDEV(performance) * (winrate * winrate) AS standard_deviation
    FROM (
           SELECT
             champion_name,
             kda,
             winrate,
             kda * winrate AS performance
           FROM (
                  SELECT
                    champions.champion_name                                                             AS champion_name,
                    (SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths) AS kda,
                    count(matches.match_win)                                                            AS games_played,
                    count(CASE WHEN matches.match_win
                      THEN 1 END) / count(matches.match_win)                                            AS winrate
                  FROM matches
                    INNER JOIN champions ON matches.champion_id = champions.champion_id
                  WHERE match_lane = 'ADC' AND matches.summoner_id = sum_id
                  GROUP BY champion_name
                ) AS calculations
         ) AS performance_calculation
    GROUP BY champion_name
    ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;


-- top_three_sup --
-- Gets the top 3 champions the summoner played in the bottom lane as support
DROP PROCEDURE IF EXISTS top_three_sup;
DELIMITER $$
CREATE PROCEDURE
	top_three_sup(
	IN sum_id BIGINT
)
	BEGIN
		SELECT
      champion_name,
      kda,
      winrate,
      performance,
      STDDEV(winrate) * STDDEV(performance) +
      STDDEV(winrate) * (performance * performance) +
      STDDEV(performance) * (winrate * winrate) AS standard_deviation
    FROM (
           SELECT
             champion_name,
             kda,
             winrate,
             kda * winrate AS performance
           FROM (
                  SELECT
                    champions.champion_name                                                             AS champion_name,
                    (SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths) AS kda,
                    count(matches.match_win)                                                            AS games_played,
                    count(CASE WHEN matches.match_win
                      THEN 1 END) / count(matches.match_win)                                            AS winrate
                  FROM matches
                    INNER JOIN champions ON matches.champion_id = champions.champion_id
                  WHERE match_lane = 'SUP' AND matches.summoner_id = sum_id
                  GROUP BY champion_name
                ) AS calculations
         ) AS performance_calculation
    GROUP BY champion_name
    ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;

-- Analysis Procedures --
/*
CALL top_three_top(123456789);
CALL top_three_top(234567890);

CALL top_three_jng(123456789);
CALL top_three_jng(234567890);

CALL top_three_mid(123456789);
CALL top_three_mid(234567890);

CALL top_three_adc(123456789);
CALL top_three_adc(234567890);

CALL top_three_sup(123456789);
CALL top_three_sup(234567890);
*/
-- View Tables --
/*
SELECT * FROM summoners;
SELECT * FROM leagues;
SELECT * FROM matches;
SELECT * FROM champions;
SELECT * FROM richard_history;
SELECT * FROM nick_history;
SELECT * FROM active_summoner;
*/