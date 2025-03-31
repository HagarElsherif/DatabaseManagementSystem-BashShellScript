#!/bin/bash



# Prompt for table name
echo -e "\e[35m"
read -r -p "Enter the name of the table: " table_name
echo -e "\e[0m"
table_file="$DB_DIR/${table_name}_metadata.txt"
table_file_data="$DB_DIR/$table_name.txt"

if [ ! -f "$table_file" ]; then
  echo -e "\e[31m"
  echo -e "Table is not found"
  echo -e "\e[0m"
  return
fi

if [ ! -f "$table_file_data" ]; then
  echo -e "\e[31m"
  echo -e "No data found"
  echo -e "\e[0m"
  return
fi

echo -e "\e[34m"
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
    if(rows == 0){
      print "No data found"
    }
    else{
      print "rows = "rows
    }
  }
  ' "$table_file_data" 
echo -e "\e[0m" 