#!/bin/bash



db_menu(){
   PS3="Enter your choice number: "
  select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update Table"
  do
  case $REPLY in
  "1")
    . ./create_table.sh
      ;;
  "2")
      
      ;;
  "3")
      .
      ;;
  "4")
    
      ;;
  * )
       echo "Enter an option from the menu"
      ;;  
  esac
  done

}


DB_DIR="dbms"


if [ -d "$DB_DIR" ]; then 

    read -p "Enter the database to connect with : " dbName
    if [ -d "./$DB_DIR/$dbName" ]; then
      db_menu 
    else
        echo "The database '$dbName' does not exist ."
    fi


fi
