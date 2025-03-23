#!/bin/bash



db_menu(){

    while true;do
        echo -e "\n1) Create Table\n2) List Tables\n3) Drop Table\n4) Insert into Table\n5) Select All from Table\n6) Select Specific from Table\n7) Delete from Table\n8) Update Table\n9) Return to main menu\n"
        read -p "Enter your choice number: " option
        case $option in
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
        "5")
            . ./all_select_from_table.sh $1
            ;;
        "6")
            . ./specific_select_from_table.sh $1
            ;;   
        "9")
            . ./main_menu.sh
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
      DB_DIR+="/$dbName"
      db_menu $dbName
    else
        echo "The database '$dbName' does not exist ."
    fi


fi
