#!/bin/bash 
PSQL="psql --username=freecodecamp --dbname=guessing_game -t --no-align -c"
echo -e "\nWelcome To the Random Guessing Game\n"

echo "Enter your username:"
read NAME
USERNAME=$($PSQL "SELECT username FROM players WHERE username='$NAME'")
if [[ -z $USERNAME ]]
then 
  echo "Welcome, $NAME! It looks like this is your first time here."
  INSERT=$($PSQL "INSERT INTO players(username) VALUES('$NAME')")
else 
  BESTGAME=$($PSQL "SELECT best_game FROM players WHERE username='$NAME'")
  NUMGAMES=$($PSQL "SELECT number_of_games FROM players WHERE username='$NAME'")
  echo "Welcome back, $NAME! You have played $NUMGAMES games, and your best game took $BESTGAME guesses."
fi
RAND=$(( $RANDOM % 10 + 1 ))
COUNTER=0
BOOL=0
echo -e "\nGuess the secret number between 1 and 1000:"
while [[ $BOOL == 0 ]]
do 
  read NUM
  if [[ "$NUM" =~ ^[0-9]+$ ]]
  then 
    COUNTER=$(( $COUNTER+1 ))
    if [[ $NUM > $RAND ]]
    then 
      echo "It's lower than that, guess again:"
    elif [[ $NUM < $RAND ]]
    then 
      echo "It's higher than that, guess again:"
    else 
      BOOL=1
    fi
  else 
    echo "That is not an integer, guess again:"
  fi
done  
echo "You guessed it in $COUNTER tries. The secret number was $RAND. Nice job!"
BESTGAME=$($PSQL "SELECT best_game FROM players WHERE username='$NAME'")
if [[ -z $BESTGAME ]]
then 
  T=$($PSQL "UPDATE players SET best_game=$COUNTER WHERE username='$NAME'")
elif [[ $BESTGAME > $COUNTER ]]
then 
  T=$($PSQL "UPDATE players SET best_game=$COUNTER WHERE username='$NAME'")
fi
NUMGAMES=$($PSQL "SELECT number_of_games FROM players WHERE username='$NAME'")
NUMGAMES=$(( $NUMGAMES + 1 ))
U=$($PSQL "UPDATE players SET number_of_games=$NUMGAMES WHERE username='$NAME'")
