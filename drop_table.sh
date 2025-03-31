#!/bin/bash
echo -e "\e[35m" 
read -r -p "Enter the table name to delete: " tablename
echo -e "\e[0m" 

TABLE_FILE="$DB_DIR/$tablename.txt"
METADATA_FILE="$DB_DIR/${tablename}_metadata.txt"


if [ -f "$METADATA_FILE" ]; then
    echo -e "\e[35m" 
    read -r -p "Are you sure you want to delete the table '$tablename'? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm "$METADATA_FILE"
        if [ -f "$TABLE_FILE" ]; then
        rm "$TABLE_FILE"
        fi
        echo -e "\e[0m" 
        echo -e "\e[92m" 
        echo "The table '$tablename' has been deleted."
        echo -e "\e[0m" 
    else 
        echo -e "\e[0m" 
        echo -e "\e[31m" 
        echo "Operation canceled. The table '$tablename' was not deleted."
        echo -e "\e[0m" 
    fi
else
    echo -e "\e[0m" 
    echo "The table '$tablename' does not exist."
    echo -e "\e[0m" 
fi