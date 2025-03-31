#!/bin/bash

. ./validation.sh


db_menu(){

    while true;do
        echo -e "\n1) Create Table\n2) List Tables\n3) Drop Table\n4) Insert into Table\n5) Select All from Table\n6) Select Specific from Table\n7) Delete from Table\n8) Update Table\n9) Return to main menu\n"
        read -r -p "Enter your choice number: " option
        case $option in
        "1")
            . ./create_table.sh 
            ;;
        "2")
            . ./list_tables.sh 
            ;;
        "3")
            . ./drop_table.sh 
            ;;
        "4")
            . ./insert_into_table.sh 
            ;;
        "5")
            . ./all_select_from_table.sh 
            ;;
        "6")
            . ./specific_select_from_table.sh 
            ;;  
        "7")
            . ./delete_from_table.sh
            ;;  
        "8")
            . ./update_table.sh
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

    read -r -p "Enter the database to connect with : " dbName
    if [ -z "$dbName" ];then
       echo "You must specify a database"
       return 
    fi
    
    if [ -d "./$DB_DIR/$dbName" ]; then
      DB_DIR+="/$dbName"
      db_menu 
    else
        echo "The database '$dbName' does not exist ."
    fi


fi
