#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.




cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[( $winner != "winner")  && ($opponent != "opponent") ]]
  then
    #getting the team_id
    TEAM_W_ID=$($PSQL "select team_id from teams where name='$winner'")
    TEAM_O_ID=$($PSQL "select team_id from teams where name='$opponent'")

    # if not found
    if [[ -z $TEAM_W_ID ]]
    then
      # inserting team
      TEAM_W_INSERTED=$($PSQL "insert into teams(name) values('$winner') ")
      #printing the success message
      if [[ $TEAM_W_INSERTED = 'INSERT 0 1' ]]
      then 
        echo Inserted team $winner
      fi
    fi

    if [[ -z $TEAM_O_ID ]]
    then
      TEAM_O_INSERTED=$($PSQL "insert into teams(name) values('$opponent') ")
      #printing the message
      if [[ $TEAM_O_INSERTED == 'INSERT 0 1' ]]
      then 
        echo Inserted team $opponent
      fi
    fi
  fi
done








cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    #getting the team_id
    TEAM_W_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    TEAM_O_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    GAME_ID=$($PSQL "select game_id from games where year=$YEAR and winner_id=$TEAM_W_ID and opponent_id=$TEAM_O_ID and winner_goals=$WINNER_GOALS and opponent_goals=$OPPONENT_GOALS")
    
    if [[ -z $GAME_ID ]]
    then
      GAME_INSERTED=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $TEAM_W_ID, $TEAM_O_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
                          
      if [[ $GAME_INSERTED = 'INSERT 0 1' ]]
      then
        echo inserted into games
      fi
    fi
  fi
done
