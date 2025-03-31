#!/bin/bash

DB_DIR="dbms"

if [ -d "$DB_DIR" ]; then
    if [ -z "$(ls -A "$DB_DIR")" ]; then
        echo -e "\e[31m" 
        echo "There is no database"
        echo -e "\e[0m" 
    else
        echo -e "\e[34m" 
        for db in "$DB_DIR"/*; do
            echo "$(basename "$db")"
        done
        echo -e "\e[0m" 
    fi
else
    echo -e "\e[31m" 
    echo "There is no database"
    echo -e "\e[0m" 
fi
