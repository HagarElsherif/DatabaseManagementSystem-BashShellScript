#!/bin/bash



db_menu(){
   PS3="Enter your choice number: "
  select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select All from Table" "Select Specific from Table" "Delete from Table" "Update Table"
  do
  case $REPLY in
  "1")
      . ./create_table.sh $1
      ;;
  "2")
      . ./list_tables.sh $1  
      ;;
  "3")
      . ./drop_table.sh
      ;;
  "4")
      . ./insert_into_table.sh $1
      ;;

  "6")
      . ./delete_from_table.sh
      ;;
  "7")
      . ./update_table.sh
      ;;   

  "5")
      . ./all_select_from_table.sh $1
      ;;
  "6")
      . ./specific_select_from_table.sh $1
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
      db_menu $dbName
    else
        echo "The database '$dbName' does not exist ."
    fi


fi
