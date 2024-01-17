#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$1

#check if user has passed an argument
if [[ -z $ELEMENT ]]
then
  echo "Please provide an element as an argument."
  exit
else
  #check if arg is a number
  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    #if not then find the length of the arg
    LENGTH=$(echo -n "$ELEMENT" | wc -m)
    if [[ $LENGTH -gt 2 ]]
    then
      #query by name
      E_BY_NAME=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$ELEMENT'")
      echo $E_BY_NAME | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        if [[ $ELEMENT != $NAME ]]
        then
          echo "I could not find that element in the database."
        else
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
      done
    else
      #query by symbol
      E_BY_SYMBOL=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$ELEMENT'")
      echo $E_BY_SYMBOL | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        if [[ $ELEMENT != $SYMBOL ]]
        then
          echo "I could not find that element in the database."
        else
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
      done
    fi
  else
    #query by atomic_number
    E_BY_AN=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number='$ELEMENT'")
      echo $E_BY_AN | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        if [[ $ELEMENT != $ATOMIC_NUMBER ]]
        then
          echo "I could not find that element in the database."
        else
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
      done
  fi
fi
