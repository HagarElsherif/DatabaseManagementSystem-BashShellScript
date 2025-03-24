#!/bin/bash


# Prompt for table name
echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_data="$DB_DIR/$table_name.txt"

# Check if table exists
if [ ! -f "$table_file" ]; then
    echo "Table does not exist."
    return
fi

# Read column names and types
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
cols_types=$(sed -n '3,$p' "$table_file" | cut -d: -f2)
readarray -t cols_names_array <<< "$cols_names"
readarray -t cols_types_array <<< "$cols_types"

# Function to check integer input
check_int(){
  if [[ $1 =~ ^[0-9]+$ ]]; then
    return 0
  else
    echo -e "Invalid Integer \n"
    return 1
   fi
}

# Function to check string input
check_string(){
    if [[ -z "$1" ]]; then
        echo -e "Error: Empty input\n"
        return 1
    fi

    if [[ "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_@.\ ]*$ ]]; then
        return 0
    else
        echo -e "Invalid string format\n"
        return 1
    fi
}

# Function to ensure Primary Key is unique
check_PK(){
    grep -q "^$1:" "$table_data" && echo "The primary key must be unique" && return 1 || return 0
}

# Ask for the column to filter by
echo "Select the column to filter by:"
for i in "${!cols_names_array[@]}"; do
    echo "$((i+1))) ${cols_names_array[i]}"
done

read -p "Enter column number: " filter_col_num
if [[ ! $filter_col_num =~ ^[0-9]+$ ]] || ((filter_col_num < 1 || filter_col_num > ${#cols_names_array[@]})); then
    echo "Invalid column number. Returning to menu..."
    return
fi

# Ask for the value to search for
read -p "Enter the value to search for: " filter_value

# Find matching row(s) and get line number
matched_line=$(awk -F: -v col="$filter_col_num" -v value="$filter_value" '$col == value {print NR}' "$table_data")

if [ -z "$matched_line" ]; then
    echo "No records found with '${cols_names_array[filter_col_num-1]}' = '$filter_value'. Returning to menu..."
    return
fi

echo "Matching record found:"
sed -n "${matched_line}p" "$table_data"

# Ask for the column to update
echo "Select the column to update:"
for i in "${!cols_names_array[@]}"; do
    echo "$((i+1))) ${cols_names_array[i]}"
done

read -p "Enter column number to update: " update_col_num
if [[ ! $update_col_num =~ ^[0-9]+$ ]] || ((update_col_num < 1 || update_col_num > ${#cols_names_array[@]})); then
    echo "Invalid column number. Returning to menu..."
    return
fi

# Ask for new value and validate it
while true; do
    read -p "Enter new value: " new_value

    data_type=${cols_types_array[update_col_num-1]}

    if [ "$update_col_num" -eq 1 ]; then
        check_PK "$new_value" || continue
    fi

    if [ "$data_type" = "int" ]; then
        check_int "$new_value" && break
    else
        check_string "$new_value" && break
    fi
done

# Update the row in the file
awk -F: -v col="$update_col_num" -v value="$filter_value" -v new="$new_value" -v line="$matched_line" '
BEGIN {OFS=":"}
NR == line { $col = new }
{ print }
' "$table_data" > temp && mv temp "$table_data"

echo "Record updated successfully."
