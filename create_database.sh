#!/bin/bash

if [ ! -d "dbms" ]; then
    mkdir dbms
    DB_DIR="dbms"
fi


read -p "Enter the database name: " db_name


if [[ "$db_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        
    if [ -d "$DB_DIR/$db_name" ]; then
        echo "The database '$db_name' already exists '."
    else
        mkdir "$DB_DIR/$db_name"
        echo "Database '$db_name' has been created'."
    fi

else
    echo "Invalid database name! It must start with a character and can only contain characters, digits, or underscores."
fi

