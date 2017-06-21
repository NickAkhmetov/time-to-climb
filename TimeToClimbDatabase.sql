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
	summoner_level INT          NOT NULL
);

DROP TABLE IF EXISTS leagues;
CREATE TABLE leagues
(
	league_season INT 			PRIMARY KEY,
	league_rank   VARCHAR(100) 	NOT NULL,
	summoner_id   BIGINT,
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
	match_role    VARCHAR(100) 	NOT NULL,
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

INSERT INTO summoners VALUES
	(1, 1, "wizard7913", 30),
	(2, 2, "MagicallyLewd", 30);

INSERT INTO leagues VALUES
	(2, "Gold 3", 1),
	(3, "Gold 1", 1),
	(4, "Platinum 5", 1),
	(5, "Masters", 1);

INSERT INTO champions VALUES
	(1, "Wukong", "tank"),
	(2, "Malphite", "tank"),
    (3, "Lux", "mage");

INSERT INTO matches VALUES
	(1, 5, "tank", "top", true, 5, 5, 5, 135, 1, 1),
	(2, 5, "tank", "top", true, 6, 6, 0, 135, 2, 1),
	(4, 5, "mage", "mid", true, 20, 6, 8, 180, 3, 2),
	(5, 5, "tank", "top", true, 8, 8, 4, 80, 2, 2),
	(3, 5, "tank", "top", false, 7, 7, 0, 135, 2, 1);

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

CALL retrieve_summoner('wizard7913');
CALL retrieve_summoner('MagicallyLewd');

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

CALL retrieve_leagues(1);

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
		kda * winrate AS performance 
	FROM ( 
		SELECT
			champions.champion_name 																			AS champion_name,
			(SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths)					AS kda,
			count(matches.match_win)                                                                       		AS games_played,
			count(CASE WHEN matches.match_win THEN 1 END)/count(matches.match_win)                         		AS winrate
		FROM matches INNER JOIN champions ON matches.champion_id = champions.champion_id
		WHERE match_lane = 'TOP' AND matches.summoner_id = sum_id
		GROUP BY champion_name
		) AS calculations
	ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;

CALL top_three_top(1);
CALL top_three_top(2);

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
		kda * winrate AS performance 
	FROM ( 
		SELECT
			champions.champion_name 																			AS champion_name,
			(SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths)					AS kda,
			count(matches.match_win)                                                                       		AS games_played,
			count(CASE WHEN matches.match_win THEN 1 END)/count(matches.match_win)                         		AS winrate
		FROM matches INNER JOIN champions ON matches.champion_id = champions.champion_id
		WHERE match_lane = 'JNG' AND matches.summoner_id = sum_id
		GROUP BY champion_name
		) AS calculations
	ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;

CALL top_three_jng(1);

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
		kda * winrate AS performance 
	FROM ( 
		SELECT
			champions.champion_name 																			AS champion_name,
			(SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths)					AS kda,
			count(matches.match_win)                                                                       		AS games_played,
			count(CASE WHEN matches.match_win THEN 1 END)/count(matches.match_win)                         		AS winrate
		FROM matches INNER JOIN champions ON matches.champion_id = champions.champion_id
		WHERE match_lane = 'MID' AND matches.summoner_id = sum_id
		GROUP BY champion_name
		) AS calculations
	ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;

CALL top_three_mid(1);
CALL top_three_mid(2);

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
		kda * winrate AS performance 
	FROM ( 
		SELECT
			champions.champion_name 																			AS champion_name,
			(SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths)					AS kda,
			count(matches.match_win)                                                                       		AS games_played,
			count(CASE WHEN matches.match_win THEN 1 END)/count(matches.match_win)                         		AS winrate
		FROM matches INNER JOIN champions ON matches.champion_id = champions.champion_id
		WHERE match_lane = 'BOT' AND match_role = 'DUO_CARRY' AND matches.summoner_id = sum_id
		GROUP BY champion_name
		) AS calculations
	ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;

CALL top_three_adc(1);

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
		kda * winrate AS performance 
	FROM ( 
		SELECT
			champions.champion_name 																			AS champion_name,
			(SUM(matches.match_kills) + SUM(matches.match_assists)) / SUM(matches.match_deaths)					AS kda,
			count(matches.match_win)                                                                       		AS games_played,
			count(CASE WHEN matches.match_win THEN 1 END)/count(matches.match_win)                         		AS winrate
		FROM matches INNER JOIN champions ON matches.champion_id = champions.champion_id
		WHERE match_lane = 'BOT' AND match_role = 'DUO_SUPPORT' AND matches.summoner_id = sum_id
		GROUP BY champion_name
		) AS calculations
	ORDER BY performance DESC
	LIMIT 3;
	END$$
DELIMITER ;

CALL top_three_sup(1);


-- View Tables --
SELECT * FROM summoners;
SELECT * FROM leagues;
SELECT * FROM matches;
SELECT * FROM champions;
