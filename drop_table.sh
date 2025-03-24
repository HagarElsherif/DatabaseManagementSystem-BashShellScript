#!/bin/bash

read -p "Enter the table name to delete: " tablename

TABLE_FILE="$DB_DIR/$tablename.txt"
METADATA_FILE="$DB_DIR/${tablename}_metadata.txt"


if [ -f "$METADATA_FILE" ]; then
    read -p "Are you sure you want to delete the table '$tablename'? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm "$METADATA_FILE"
        if [ -f "$TABLE_FILE" ]; then
        rm "$TABLE_FILE"
        fi
        echo "The table '$tablename' has been deleted."
    else
        echo "Operation canceled. The table '$tablename' was not deleted."
    fi
else
    echo "The table '$tablename' does not exist."
fi