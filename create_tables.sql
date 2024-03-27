CREATE TABLE teams(
	team_id SERIAL NOT NULL,
	name VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY (team_id)
);

CREATE TABLE games(
	game_id SERIAL NOT NULL,
	year INT NOT NULL,
	round VARCHAR(20) NOT NULL,
	winner_goals INT NOT NULL,
	opponent_goals INT NOT NULL,
	winner_id INT NOT NULL,
	opponent_id INT NOT NULL,
	PRIMARY KEY (game_id),
	FOREIGN KEY (winner_id) REFERENCES teams(team_id),
	FOREIGN KEY (opponent_id) REFERENCES teams(team_id)
);
