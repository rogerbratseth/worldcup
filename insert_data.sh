#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
	if [[ $YEAR != year ]]
	then
		# get winner_id
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
		# if not found
		if [[ -z $WINNER_ID ]]
		then
			# insert winner
			INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
			then
				# get new winner_id
				WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
				echo Inserted into teams, $WINNER, id $WINNER_ID
			fi
		fi

		# get opponent_id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
		# if not found
		if [[ -z $OPPONENT_ID ]]
		then
			# insert opponent
			INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
			then
				# get new opponent_id
				OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
				echo Inserted into teams, $OPPONENT, id $OPPONENT_ID
			fi
		fi


		# insert game
		# INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES();
		INSERT_GAME_RESULT=$($PSQL " \
			INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) \
			VALUES($YEAR, '$ROUND', $W_GOALS, $O_GOALS, $WINNER_ID, $OPPONENT_ID)")
		if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
		then
			echo Inserted into games, $YEAR $ROUND winner $WINNER opponent $OPPONENT
		fi
	fi
done

