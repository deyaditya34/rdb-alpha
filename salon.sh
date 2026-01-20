#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

display_services() {
SERVICES=$($PSQL "select service_id, name from services order by service_id")
echo "$SERVICES" | while IFS="|" read SERVICE_ID NAME
  do
    SERVICE_ID=$(echo $SERVICE_ID | sed 's/^ *//;s/ *$//')
    NAME=$(echo $NAME | sed 's/^ *//;s/ *$//')
    echo "$SERVICE_ID) $NAME"
  done
}

while true
do
display_services
echo -e "\nEnter a service id"

read SERVICE_ID_SELECTED

SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
SERVICE_NAME=$(echo $SERVICE_NAME | sed 's/^ *//;s/ *$//')

if [[ -z $SERVICE_NAME ]]
then
  echo "I could not find that service."
else break
fi
done

echo -e "\nPlease enter your phone number"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed 's/^ *//;s/ *$//')
echo "customer name: $CUSTOMER_NAME"
if [[ -z $CUSTOMER_NAME ]]
then
  echo "Please enter your name"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi

echo "Please enter your appointment time"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

