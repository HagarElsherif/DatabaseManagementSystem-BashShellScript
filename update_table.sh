#!/bin/bash


# Prompt for table name
echo -e "\e[35m" 
read -r -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_data="$DB_DIR/$table_name.txt"
echo -e "\e[0m" 
echo -e "\e[31m" 
# Check if table exists
if [ ! -f "$table_file" ]; then
    echo "Table does not exist."
    return
fi
echo -e "\e[0m" 
# Read column names and types
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
cols_types=$(sed -n '3,$p' "$table_file" | cut -d: -f2)
readarray -t cols_names_array <<< "$cols_names"
readarray -t cols_types_array <<< "$cols_types"

echo -e "\e[35m" 
# Ask for the column to filter by
echo "Select the column to filter by:"
echo -e "\e[0m" 
echo -e "\e[39m" 
for i in "${!cols_names_array[@]}"; do
    echo "$((i+1))) ${cols_names_array[i]}"
done
echo -e "\e[0m" 

echo -e "\e[35m" 
read -r -p "Enter column number: " filter_col_num
echo -e "\e[0m" 


if [[ ! $filter_col_num =~ ^[0-9]+$ ]] || ((filter_col_num < 1 || filter_col_num > ${#cols_names_array[@]})); then
    echo -e "\e[31m" 
    echo "Invalid column number. Returning to menu..."
    echo -e "\e[0m" 

    return
fi

# Ask for the value to search for
echo -e "\e[35m" 
read -r -p "Enter the value to search for: " filter_value
echo -e "\e[0m" 

# Find matching row(s) and get line number
matched_line=$(awk -F: -v col="$filter_col_num" -v value="$filter_value" '$col == value {print NR}' "$table_data")

echo -e "\e[31m" 

if [ -z "$matched_line" ]; then
    echo "No records found with '${cols_names_array[filter_col_num-1]}' = '$filter_value'. Returning to menu..."
    return
fi
echo -e "\e[0m" 

echo -e "\e[92m" 

echo "Matching record found:"
echo -e "\e[0m" 

sed -n "${matched_line}p" "$table_data"

# Ask for the column to update
echo "Select the column to update:"
for i in "${!cols_names_array[@]}"; do
    echo "$((i+1))) ${cols_names_array[i]}"
done

read -p "Enter column number to update: " update_col_num
if [[ ! $update_col_num =~ ^[0-9]+$ ]] || ((update_col_num < 1 || update_col_num > ${#cols_names_array[@]})); then
    echo -e "\e[31m" 

    echo "Invalid column number. Returning to menu..."
    echo -e "\e[0m" 

    return
fi

# Ask for new value and validate it
while true; do
    echo -e "\e[31m" 

    read -r -p "Enter new value: " new_value
    echo -e "\e[0m" 

    data_type=${cols_types_array[update_col_num-1]}

    if [ "$update_col_num" -eq 1 ]; then
        check_PK "$new_value" || continue
    fi

     case "$data_type" in
        "int")
            check_int "$new_value" && break
            ;;
        "string")
            check_string "$new_value" && break
            ;;
        "date")
            check_date "$new_value" && break
            ;;
        "time")
            check_time "$new_value" && break
            ;;
        *)
            echo -e "\e[31m" 

            echo "Unknown data type."
            echo -e "\e[0m" 

            break
            ;;
    esac
done

# Update the row in the file
awk -F: -v col="$update_col_num" -v value="$filter_value" -v new="$new_value" -v line="$matched_line" '
BEGIN {OFS=":"}
NR == line { $col = new }
{ print }
' "$table_data" > temp && mv temp "$table_data"
echo -e "\e[92m" 

echo "Record updated successfully."
echo -e "\e[0m" 
