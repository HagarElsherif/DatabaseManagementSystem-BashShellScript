#!/bin/bash



DB_DIR="dbms/$1"

echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_data="$DB_DIR/$table_name.txt"

# Check if table exists
if [ ! -f "$table_file" ]; then
    echo "Table does not exist."
    exit 1
fi

# Read column names and types from data
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
cols_types=$(sed -n '3,$p' "$table_file" | cut -d: -f2)
readarray -t cols_names_array <<< "$cols_names"
readarray -t cols_types_array <<< "$cols_types"

# Function to check integer 
check_int(){
  if [[ $1 =~ ^[0-9]+$ ]]; then
    return 0
  else
    echo -e "Invalid Integer \n"
    return 1
   fi
}

# Function to check string 
check_string(){
    if [[ -z $1 ]]; then
        echo -e "Error: Empty input\n"
        return 1
    fi

    if [[ $1 =~ ^[a-zA-Z_][a-zA-Z0-9_\ ]*$ ]]; then
        return 0
    else
        echo -e "Invalid string format\n"
        return 1
    fi
}

# ensure Primary Key is unique
check_PK(){
    awk -v value=$1 '
    BEGIN{ FS=":" }
    { if ($1 == value) { print "The primary key must be unique"; exit 1 } }
    END{}
    ' $table_data
}


read -p "Enter the Primary Key value to update: " pk_value

# Find the row containing the Primary Key
row=$(awk -F: -v pk="$pk_value" '$1 == pk {print; found=1} END {if (!found) exit 1}' "$table_data")

if [ $? -ne 0 ]; then
    echo "Error: No record found with Primary Key '$pk_value'."
    exit 1
fi

# Display columns
echo "Select the column to update:"
for i in "${!cols_names_array[@]}"; do
    echo "$((i+1))) ${cols_names_array[i]}"
done

read -p "Enter column number: " col_num

# Validate column number
if [[ ! $col_num =~ ^[0-9]+$ ]] || ((col_num < 1 || col_num > ${#cols_names_array[@]})); then
    echo "Invalid column number."
    exit 1
fi


while true; do
    read -p "Enter new value: " new_value

    # Validate input based on type
    data_type=${cols_types_array[col_num-1]}

    if [ "$col_num" -eq 1 ]; then
        check_PK "$new_value" || continue
    fi

    if [ "$data_type" = "int" ]; then
        check_int "$new_value" && break
    else
        check_string "$new_value" && break
    fi
done


awk -F: -v pk="$pk_value" -v col="$col_num" -v new="$new_value" '
BEGIN {OFS=":"}
$1 == pk { $col = new }
{ print }
' "$table_data" > temp && mv temp "$table_data"

echo "Record updated successfully."
