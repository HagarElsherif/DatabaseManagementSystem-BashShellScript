#!/bin/bash


readarray -t tables < <(find "${DB_DIR}" -maxdepth 1 -type f -name "*_metadata.txt"  )



length=${#tables[@]}



if [[ $length -eq 0 ]];then
  echo -e "\e[31m" 
  echo -e "No tables found"
  echo -e "\e[0m" 
else
  echo -e "\e[34m" 
  for ((i=0; i<$length; i++)); do
    sed -n "1p"  "${tables[i]}"
  done  
  echo -e "\e[0m" 
fi
