#!/bin/bash


while true; do
    # Prompt for table name
    echo -e "\e[35m" 
    read -r -p "Enter the name of the table: " table_name
    echo -e "\e[0m" 
    table_file="$DB_DIR/${table_name}_metadata.txt"

    # Validate table name (must start with a letter and contain only alphanumeric and underscores)
    if ! [[ "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo -e "\e[31m" 
        echo -e "Error: Invalid table name. It must start with a letter and contain only letters, numbers, or underscores.\n"
        echo -e "\e[0m" 
    # Check if the table already exists
    elif [ -f "$table_file" ]; then
        echo -e "\e[31m" 
        echo -e "Error: Table '$table_name' already exists.\n"
        echo -e "\e[0m" 
    else
       break
    fi

done


while true; do

    # Prompt for number of columns
    echo -e "\e[35m" 
    read -r -p "Enter the number of columns in the table: " no_columns
    echo -e "\e[0m" 
    # Validate column count (must be a positive integer)
    if ! [[ "$no_columns" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "\e[31m" 
        echo -e "Error: Invalid number of columns. Must be a positive integer. \n"
        echo -e "\e[0m" 
    else
        break
    fi

done


# Create table file
touch "$table_file" || { echo "Error: Failed to create table file."; return; }

# Write table name and column count to file
echo "$table_name" > "$table_file"
echo "$no_columns" >> "$table_file"

unset column_names
declare -A column_names # To ensure uniqueness

# Function to validate column names
validate_column_name() {
    local name="$1"
    if ! [[ "$name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo -e "\e[31m" 
        echo -e "Error: Invalid column name '$name'. It must start with a letter and contain only letters, numbers, or underscores.\n"
        echo -e "\e[0m" 
        return 1
    fi
    if [[ -n "${column_names[$name]}" ]]; then
        echo -e "\e[31m" 
        echo -e "Error: Column name '$name' is already used. Please enter a unique column name.\n"
        echo -e "\e[0m" 
        return 1
    fi
    column_names["$name"]=1
    return 0
}

# Collect column names and data types
for ((i=1; i<=no_columns; i++))
do
    if [[ $i -eq 1 ]]; then
        echo -e "\e[34m" 
        echo -e "\nFirst column is the PRIMARY KEY.\n"
        echo -e "\e[0m" 
    fi

    while true; do
        echo -e "\e[35m" 
        read -r -p "Enter the name of column $i: " col_name
        echo -e "\e[0m" 
        validate_column_name "$col_name" && break
    done

    while true; do
        
        echo -e "\e[35m" 
        read -r -p "Enter the data type of the column (int/string/date/time): " col_datatype
        echo -e "\e[0m" 
        if [[ "$col_datatype" == "int" || "$col_datatype" == "string" || "$col_datatype" == "date" || "$col_datatype" == "time" ]]; then
            break
        else
            echo -e "\e[31m" 
            echo -e "Error: Invalid data type. Please enter 'int' or 'string'.\n"
            echo -e "\e[0m" 
        fi
    done

    if [[ $i -eq 1 ]]; then
        echo "$col_name:$col_datatype:pk" >> "$table_file"
    else
        echo "$col_name:$col_datatype" >> "$table_file"
    fi
done
echo -e "\e[92m" 
echo -e "Success: Table '$table_name' created in database '$DB_DIR'.\n"
echo -e "\e[0m" 



