#!/bin/bash


# Prompt for table name
echo -e "\e[35m" 
read -r -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"
table_file_data="$DB_DIR/$table_name.txt"
read -r -p "Enter the column name : " col_name
read -r -p "Enter the value : " value
echo -e "\e[0m" 

echo -e "\e[31m" 
if [ ! -f "$table_file" ]; then
  echo -e "Table is not found"
  return
fi
echo -e "\e[0m" 

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
    echo -e "\e[31m" 
    echo -e "There is no column with that name\n"
    echo -e "\e[0m" 
    return
fi

if [ ! -f "$table_file_data" ]; then
    echo -e "\e[31m" 
    echo -e "No data found"
    echo -e "\e[0m" 
    return
fi   


((col_num++))
table_header=$(echo "${cols_names_array[@]}")
table_header="${table_header// / | }"
echo ${table_header}
echo -e "\e[34m" 
awk -v col="${col_num}" -v val="${value}" '
  BEGIN{ 
    FS=":"
    rows=0
  }
  {
    if($col == val){
      gsub(":", " | ", $0);
      print $0
      rows+=1
    }
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