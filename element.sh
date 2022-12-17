#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $ATOMIC_NUMBER")
    echo $ELEMENT_INFO | while read NAME LINE SYMBOL LINE TYPE LINE MASS LINE MELTING_POINT LINE BOILING_POINT
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
else
  echo Please provide an element as an argument.
fi