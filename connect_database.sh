#!/bin/bash

. ./validation.sh


db_menu(){

    while true;do
        
        echo -e "\e[93m\n1) Create Table\n2) List Tables\n3) Drop Table\n4) Insert into Table\n5) Select All from Table\n6) Select Specific from Table\n7) Delete from Table\n8) Update Table\n9) Return to main menu\n"
        echo -e "\e[0m"
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
            echo -e "\e[31m"
            echo "Enter an option from the menu"
            echo -e "\e[0m"
            ;;  
        esac
 

    done




}


DB_DIR="dbms"


if [ -d "$DB_DIR" ]; then 
    echo -e "\e[35m"
    read -r -p "Enter the database to connect with : " dbName
    echo -e "\e[0m"
    if [ -z "$dbName" ];then
       echo -e "\e[31m"
       echo "You must specify a database"
       echo -e "\e[0m"
       return 
    fi
    
    if [ -d "./$DB_DIR/$dbName" ]; then
      DB_DIR+="/$dbName"
      db_menu 
    else
        echo -e "\e[31m"
        echo "The database '$dbName' does not exist ."
        echo -e "\e[0m"
    fi


fi
