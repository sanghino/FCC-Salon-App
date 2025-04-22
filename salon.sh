#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

LIST_SERVICES(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT * FROM SERVICES ORDER BY SERVICE_ID")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE=$($PSQL "SELECT name FROM SERVICES WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE ]]
  then
    LIST_SERVICES "I could not find that service. What would you like today?"
  else
    MAIN_MENU
  fi

}

MAIN_MENU(){

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM CUSTOMERS WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NEWCUSTOMER=$($PSQL "INSERT INTO customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  SERVICE_FORMATTED=$(echo $SERVICE | sed 's/\s//g' -E)
  NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/\s//g' -E)
  echo -e "\nWhat time would you like your $SERVICE_FORMATTED, $NAME_FORMATTED?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM CUSTOMERS WHERE name = '$NAME_FORMATTED'")
  SERVICE_ID=$($PSQL "SELECT service_id FROM serviceS WHERE name = '$SERVICE_FORMATTED'")
  NEWAPPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $NAME_FORMATTED."

}

LIST_SERVICES
