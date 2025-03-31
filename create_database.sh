#!/bin/bash

if [ ! -d "dbms" ]; then
    mkdir dbms
fi


read -r -p "Enter the database name: " db_name


if [[ "$db_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        
    if [ -d "dbms/$db_name" ]; then
        echo "The database '$db_name' already exists '."
    else
        mkdir "dbms/$db_name"
        echo "Database '$db_name' has been created'."
    fi

else
    echo "Invalid database name! It must start with a character and can only contain characters, digits, or underscores."
fi

