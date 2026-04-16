#!/bin/bash

PSQL="docker exec bike-db psql -U postgres -d bike_rental -t -P pager=off -c"

echo -e "\n~~ Bike Rental Shop ~~\n";

MAIN_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nHow may I help you?"
  echo -e "\n1. Rent a bike\n2. Return a bike\n3. Exit"
  read MAIN_MENU_SELECTION
  
  case $MAIN_MENU_SELECTION in
    1) RENT_MENU ;;
    2) RETURN_MENU ;;
    3) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

RENT_MENU () {
  #get available bikes
  AVAILABLE_BIKES=$($PSQL "SELECT bike_id, type, size FROM bikes WHERE available = true ORDER BY bike_id;")
  
  #if no bikes available
  if [[ -z $AVAILABLE_BIKES ]]
  then 
    #send to main menu
    MAIN_MENU "Sorry, we don't have any bikes available right now."
  else
    #display available bikes
    echo -e "\nHere are the bikes we have available:\n"
    echo -e "$AVAILABLE_BIKES" | while read BIKE_ID BAR TYPE BAR SIZE
    do
      echo "$BIKE_ID) $SIZE\" $TYPE Bike"
    done
    #ask for bike to rent
    echo -e "\nWhich one would you like to rent?"
    read BIKE_ID_TO_RENT
    #if input is not a number
    if [[ ! $BIKE_ID_TO_RENT =~ ^[0-9]+$ ]]
    then
      #send to main menu
      MAIN_MENU "That is not a valid bike number"
    else
      #get bike availability
      BIKE_AVAILABILITY="$($PSQL "SELECT available FROM bikes WHERE available = true AND  bike_id = $BIKE_ID_TO_RENT;")"
      #if not available
      if [[ -z $BIKE_AVAILABILITY ]]
      then
        #send to main menu
        MAIN_MENU "that bike is not available"
      else
        #get customer info
        echo -e "\nWhat's your phone number?"
        read PHONE_NUMBER
        CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone = '$PHONE_NUMBER';")"
        #if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
          #get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
          #insert new customer
          INSERT_CUSTOMER_RESULT="$($PSQL "INSERT INTO customers (phone, name) VALUES ('$PHONE_NUMBER', '$CUSTOMER_NAME');")"
        fi
      fi
    fi
  fi
  
}

RETURN_MENU () {
  echo "Return Menu"
}

EXIT () {
  echo -e "\nThank you for shopping in.\n"
}


MAIN_MENU