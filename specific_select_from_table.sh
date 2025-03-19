#!/bin/bash


# Ensure a database name is provided
if [ -z "$1" ]; then
    echo -e "Usage: $0 <database_name>\n"
    exit 1
fi

DB_DIR="dbms/$1"

# Check if the database directory exists
if [ ! -d "$DB_DIR" ]; then
    echo -e "Error: Database '$1' does not exist.\n"
    exit 1
fi


# Prompt for table name
echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_file_data="$DB_DIR/$table_name.txt"
read -p "Enter the column name : " col_name
read -p "Enter the value : " value


if [ ! -f "$table_file" ]; then
  echo -e "Table is not found"
  exit 1
fi
 

readarray -t cols_names_array <<< "$(cut -d : -f1 "${table_file}" | sed -n '3,$p')"


col_num=""
for ((i = 0; i < ${#cols_names_array[@]}; i++)); do
    if [[ "${cols_names_array[i]}" == "$col_name" ]]; then
        col_num=$i
        break
    fi
done

# Check if col_num is set
if [[ -z "$col_num" ]]; then
    echo -e "There is no column with that name\n"
    exit 1
fi

if [ ! -f "$table_file_data" ]; then
    echo -e "No data found"
    exit 0
fi   


((col_num++))
table_header=$(echo "${cols_names_array[@]}")
table_header="${table_header// / | }"
echo ${table_header}

awk -v col="${col_num}" -v val="${value}" '
  BEGIN{ 
    FS=":"
  }
  {
    if($col == val){
      gsub(":", " | ", $0);
      print $0
    }
  }
  END{}
  ' "$table_file_data" 
