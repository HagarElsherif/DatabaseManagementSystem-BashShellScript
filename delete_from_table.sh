#!/bin/bash
echo -e "\e[35m" 
read -r -p "Enter the name of the table: " table_name
echo -e "\e[0m" 
table_file="$DB_DIR/${table_name}_metadata.txt"
table_data="$DB_DIR/$table_name.txt"


if [ ! -f "$table_file" ]; then
    echo -e "\e[31m" 
    echo "Table does not exist."
    echo -e "\e[0m" 
    return
fi

# Read column names from metadata
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
readarray -t cols_names_array <<< "$cols_names"
echo -e "\e[93m" 
echo -e "\nChoose an option:"
echo "1) Delete all rows"
echo "2) Delete by column value"
echo -e "\e[0m" 
echo -e "\e[35m" 
read -r -p "Enter your choice: " choice
echo -e "\e[0m" 

case $choice in
1)  # Delete all rows

    if [ ! -s "$table_data" ]; then
        echo -e "\e[31m" 
        echo "Table is already empty."
        echo -e "\e[0m" 
    else
        > "$table_data"
        echo -e "\e[92m" 
        echo "All rows deleted successfully."
        echo -e "\e[0m" 
    fi
    ;;

2)  # Delete by column
    echo -e "\e[35m" 
    echo "Select a column to filter by:"
    echo -e "\e[0m" 

    echo -e "\e[93m" 
    for i in "${!cols_names_array[@]}"; do
        echo "$((i+1))) ${cols_names_array[i]}"
    done
    echo -e "\e[0m" 

    echo -e "\e[35m" 
    read -r -p "Enter column number: " col_num
    echo -e "\e[0m" 
    if [[ ! $col_num =~ ^[0-9]+$ ]] || ((col_num < 1 || col_num > ${#cols_names_array[@]})); then
        echo -e "\e[31m" 
        echo "Invalid column number."
        echo -e "\e[0m" 
        return
    fi
    echo -e "\e[35m" 
    read -r -p "Enter the value to delete: " delete_value
    echo -e "\e[0m" 

    # Count matching rows
    match_count=$(awk -F: -v col="$col_num" -v value="$delete_value" '$col == value' "$table_data" | wc -l)

    if [ "$match_count" -eq 0 ]; then
        echo -e "\e[31m" 
        echo "No records found with '${cols_names_array[col_num-1]}' = '$delete_value'."
        echo -e "\e[0m" 
    else
        awk -F: -v col="$col_num" -v value="$delete_value" '$col != value' "$table_data" > temp && mv temp "$table_data"
        echo -e "\e[92m" 
        echo "$match_count row(s) deleted successfully."
        echo -e "\e[0m" 
    fi
    ;;

*)  # Invalid choice
    echo -e "\e[31m" 
    echo "Invalid option. Please choose from the menu."
    echo -e "\e[0m" 
    return
    ;;
esac
