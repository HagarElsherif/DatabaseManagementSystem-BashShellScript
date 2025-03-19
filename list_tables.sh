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



readarray -t tables < <(find "${DB_DIR}" -maxdepth 1 -type f -name "*_metadata.txt"  )



length=${#tables[@]}



if [[ $length -eq 0 ]];then
  echo -e "No tables found"
else
  for ((i=0; i<$length; i++)); do
    sed -n "1p"  "${tables[i]}"
  done  
fi
