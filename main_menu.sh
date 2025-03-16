#!/bin/bash

PS3="Enter your choice number: "
select choice in "Create DataBase" "Delete DataBase" "Connect DataBase" "List DataBases" "Exit the program" 
do
case $REPLY in
"5")
    break
    ;;
"1")
    . ./create_database.sh
    ;;
"2")
    . ./delete_database.sh
    ;;
"3")
    . ./connect_database.sh
    ;;
"4")
    . ./list_database.sh
    ;;
esac
done



