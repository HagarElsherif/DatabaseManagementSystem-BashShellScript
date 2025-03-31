#!/bin/bash

DB_DIR="dbms"


if [ -d "$DB_DIR" ]; then 
    echo -e "\e[35m" 
    read -r -p "Enter the name of the database to delete: " dbname
    if [ -d "./$DB_DIR/$dbname" ]; then
        read -r -p "Are you sure you want to delete the database '$dbname'? (y/n): " confirm
        echo -e "\e[0m" 
        if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
            rm -r "./$DB_DIR/$dbname"
            echo -e "\e[92m" 
            echo "The database '$dbname' has been deleted."
            echo -e "\e[0m" 
        else
            echo -e "\e[31m" 
            echo "Operation canceled. The database '$dbname' was not deleted."
            
        fi
    else

        echo "The database '$dbname' does not exist."
        echo -e "\e[0m" 
    fi


fi