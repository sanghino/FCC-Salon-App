#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT * FROM SERVICES")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_SELECTION
  HAVE_SERVICE=$($PSQL "SELECT * FROM SERVICES WHERE service_id = $SERVICE_SELECTION")
  if [[ -z $HAVE_SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  fi

  echo -e "What's your phone number?\n"
  read PHONE_NUMBER
  HAVE_PHONE=$($PSQL "SELECT * FROM CUSTOMERS WHERE phone = $PHONE_NUMBER")
  if [[ -z $HAVE_PHONE ]]
  then
    echo -e "I don't have a record for that phone number, what's your name?\n"
    read NAME
  fi

}
MAIN_MENU
