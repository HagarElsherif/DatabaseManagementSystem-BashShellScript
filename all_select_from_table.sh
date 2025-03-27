#!/bin/bash



# Prompt for table name
echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_file_data="$DB_DIR/$table_name.txt"

if [ ! -f "$table_file" ]; then
  echo -e "Table is not found"
  return
fi

if [ ! -f "$table_file_data" ]; then
  echo -e "No data found"
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
    if(rows == 0){
      print "No data found"
    }
    else{
      print "rows = "rows
    }
  }
  ' "$table_file_data" 
