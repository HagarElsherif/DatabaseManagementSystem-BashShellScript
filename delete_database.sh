#!/bin/bash

DB_DIR="dbms"


if [ -d "$DB_DIR" ]; then 

    read -r -p "Enter the name of the database to delete: " dbname
    if [ -d "./$DB_DIR/$dbname" ]; then
        read -r -p "Are you sure you want to delete the database '$dbname'? (y/n): " confirm
        if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
            rm -r "./$DB_DIR/$dbname"
            echo "The database '$dbname' has been deleted."
        else
            echo "Operation canceled. The database '$dbname' was not deleted."
        fi
    else
        echo "The database '$dbname' does not exist."
    fi


fi