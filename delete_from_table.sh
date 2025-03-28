#!/bin/bash

echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_data="$DB_DIR/$table_name.txt"


# Read column names from metadata
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
readarray -t cols_names_array <<< "$cols_names"

echo -e "\nChoose an option:"
echo "1) Delete all rows"
echo "2) Delete by column value"

read -p "Enter your choice: " choice

case $choice in
1)  # Delete all rows
    if [ ! -s "$table_data" ]; then
        echo "Table is already empty."
    else
        > "$table_data"
        echo "All rows deleted successfully."
    fi
    ;;

2)  # Delete by column
    echo "Select a column to filter by:"
    for i in "${!cols_names_array[@]}"; do
        echo "$((i+1))) ${cols_names_array[i]}"
    done

    read -p "Enter column number: " col_num
    if [[ ! $col_num =~ ^[0-9]+$ ]] || ((col_num < 1 || col_num > ${#cols_names_array[@]})); then
        echo "Invalid column number."
        return
    fi

    read -p "Enter the value to delete: " delete_value

    # Count matching rows
    match_count=$(awk -F: -v col="$col_num" -v value="$delete_value" '$col == value' "$table_data" | wc -l)

    if [ "$match_count" -eq 0 ]; then
        echo "No records found with '${cols_names_array[col_num-1]}' = '$delete_value'."
    else
        awk -F: -v col="$col_num" -v value="$delete_value" '$col != value' "$table_data" > temp && mv temp "$table_data"
        echo "$match_count row(s) deleted successfully."
    fi
    ;;

*)  # Invalid choice
    echo "Invalid option. Please choose from the menu."
    return
    ;;
esac
