#!/bin/bash



DB_DIR="dbms/$1"


echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_data="$DB_DIR/$table_name.txt"


if [ ! -f "$table_file" ]; then
    echo "Table does not exist."
    exit 1
fi

# Read column names
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
readarray -t cols_names_array <<< "$cols_names"

# Ask for Primary Key value
read -p "Enter the Primary Key value to update: " pk_value

# Find the row containing the Primary Key
row=$(awk -F: -v pk="$pk_value" '$1 == pk {print; found=1} END {if (!found) exit 1}' "$table_data")

if [ $? -ne 0 ]; then
    echo "Error: No record found with Primary Key '$pk_value'."
    exit 1
fi

# Display column options
echo "Select the column to update:"
for i in "${!cols_names_array[@]}"; do
    echo "$((i+1))) ${cols_names_array[i]}"
done

# Get column choice
read -p "Enter column number: " col_num

# Validate column number
if [[ ! $col_num =~ ^[0-9]+$ ]] || ((col_num < 1 || col_num > ${#cols_names_array[@]})); then
    echo "Invalid column number."
    exit 1
fi

# Ask for new value
read -p "Enter new value: " new_value

# Update the row
awk -F: -v pk="$pk_value" -v col="$col_num" -v new="$new_value" '
BEGIN {OFS=":"}
$1 == pk { $col = new }
{ print }
' "$table_data" > temp && mv temp "$table_data"

echo "Record updated successfully."
