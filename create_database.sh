#!/bin/bash

if [ ! -d "dbms" ]; then
    mkdir dbms
fi

echo -e "\e[35m"
read -r -p "Enter the database name: " db_name
echo -e "\e[0m"

if [[ "$db_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        
    if [ -d "dbms/$db_name" ]; then
        echo -e "\e[31m"
        echo "The database '$db_name' already exists '."
        echo -e "\e[0m" 
    else
        mkdir "dbms/$db_name"
        echo -e "\e[92m" 
        echo "Database '$db_name' has been created'."
        echo -e "\e[0m" 
    fi

else
    echo -e "\e[31m" 
    echo "Invalid database name! It must start with a character and can only contain characters, digits, or underscores."
    echo -e "\e[0m" 
fi

