#!/bin/bash

# Ensure a database name is provided
if [ -z "$1" ]; then
    echo -e "Usage: $0 <database_name>\n"
    exit 1
fi





while true; do

    # Prompt for table name
    echo ""
    read -p "Enter the name of the table: " table_name
    table_file="$DB_DIR/${table_name}_metadata.txt"

    # Validate table name (must start with a letter and contain only alphanumeric and underscores)
    if ! [[ "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo -e "Error: Invalid table name. It must start with a letter and contain only letters, numbers, or underscores.\n"
    # Check if the table already exists
    elif [ -f "$table_file" ]; then
        echo -e "Error: Table '$table_name' already exists.\n"
    else
       break
    fi

done


while true; do

    # Prompt for number of columns
    echo ""
    read -p "Enter the number of columns in the table: " no_columns

    # Validate column count (must be a positive integer)
    if ! [[ "$no_columns" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "Error: Invalid number of columns. Must be a positive integer. \n"
    else
        break
    fi

done



# Create table file
touch "$table_file" || { echo "Error: Failed to create table file."; exit 1; }

# Write table name and column count to file
echo "$table_name" > "$table_file"
echo "$no_columns" >> "$table_file"

declare -A column_names # To ensure uniqueness

# Function to validate column names
validate_column_name() {
    local name="$1"
    if ! [[ "$name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo -e "Error: Invalid column name '$name'. It must start with a letter and contain only letters, numbers, or underscores.\n"
        return 1
    fi
    if [[ -n "${column_names[$name]}" ]]; then
        echo -e "Error: Column name '$name' is already used. Please enter a unique column name.\n"
        return 1
    fi
    column_names["$name"]=1
    return 0
}

# Collect column names and data types
for ((i=1; i<=no_columns; i++))
do
    if [[ $i -eq 1 ]]; then
        echo -e "\nFirst column is the PRIMARY KEY.\n"
    fi

    while true; do
        echo ""
        read -p "Enter the name of column $i: " col_name
        validate_column_name "$col_name" && break
    done

    while true; do
        echo ""
        read -p "Enter the data type of the column (int/string): " col_datatype
        if [[ "$col_datatype" == "int" || "$col_datatype" == "string" ]]; then
            break
        else
            echo -e "Error: Invalid data type. Please enter 'int' or 'string'.\n"
        fi
    done

    if [[ $i -eq 1 ]]; then
        echo "$col_name:$col_datatype:pk" >> "$table_file"
    else
        echo "$col_name:$col_datatype" >> "$table_file"
    fi
done

echo -e "Success: Table '$table_name' created in database '$1'.\n"




