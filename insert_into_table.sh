#!/bin/bash

# Prompt for table name
echo -e "\e[35m" 
read -r -p "Enter the name of the table: " table_name
echo -e "\e[0m" 
table_file="$DB_DIR/${table_name}_metadata.txt"

if [ ! -f "$table_file" ] ;then
    echo -e "\e[31m" 
    echo -e "Table is not found"
    echo -e "\e[0m" 
    return
fi 

table_data="$DB_DIR/$table_name.txt"
touch $table_data

cols_num=$(sed -n '2p' "$table_file")
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
cols_data_types=$(sed -n '3,$p' "$table_file" | cut -d: -f2)

# Convert cols_names and cols_data_types to arrays
readarray -t cols_names_array <<< "$cols_names"
readarray -t cols_data_types_array <<< "$cols_data_types"


new_data=""
for ((i=0; i<cols_num; i++)); do
    field=${cols_names_array[i]}
    data_type=${cols_data_types_array[i]}
    
    while true ;do

    echo -e "\e[35m" 
    read -r -p "Enter a value for the $field : " value
    echo -e "\e[0m" 
        if [ "$i" -eq 0 ] ;then
           check_PK $value || continue
        fi

        case $data_type in
            "int") 
                check_int "$value" && break
                ;;
            "string") 
                check_string "$value" && break
                ;;
            "date") 
                check_date "$value" && break
                ;;
            "time") 
                check_time "$value" && break
                ;;
            *) 
                echo "Unknown data type: $data_type"
                return
                ;;
        esac
    done


    new_data+="$value:"

done

new_data=${new_data::-1}
echo $new_data >> $table_data




