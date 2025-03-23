#!/bin/bash


# Ensure a database name is provided
if [ -z "$1" ]; then
    echo -e "Usage: $0 <database_name>\n"
    exit 1
fi




# Prompt for table name
echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_file_data="$DB_DIR/$table_name.txt"

if [ ! -f "$table_file" ]; then
  echo -e "Table is not found"
  return
fi

readarray -t cols_names_array <<< "$(cut -d : -f1 "${table_file}" | sed -n '3,$p')"
table_header=$(echo "${cols_names_array[@]}")
table_header="${table_header// / | }"
echo ${table_header}





awk  '
  BEGIN{ 
    FS=":"
    rows=0
  }
  {
      gsub(":", " | ", $0);
      print $0
      rows+=1
  }
  END{
  print "rows = "rows
  }
  ' "$table_file_data" 
