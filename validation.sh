#!/bin/bash


check_int(){
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    return 0
  else
    echo -e "Invalid Integer \n"
    return 1
   fi

}

check_string(){

    # Check if input is empty
    if [[ -z "$1" ]]; then
        echo -e "Error: Empty input\n"
        return 1
    fi

   
    if [[ "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_@.\ ]*$ ]]; then

        return 0
    else
        echo -e "Invalid string format\n"
        return 1
    fi

}

#Date Format YYYY-MM-DD
check_date(){
    if [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        return 0
    else
        echo -e "Invalid Date Format. Use YYYY-MM-DD \n"
        return 1
    fi
}

# Check a valid time Format: HH-MM-SS
check_time(){
    if [[ "$1" =~ ^([01][0-9]|2[0-3])-[0-5][0-9]-[0-5][0-9]$ ]]; then
        return 0
    else
        echo -e "Invalid Time Format. Use HH-MM-SS \n"
        return 1
    fi
}



# Function to ensure Primary Key is unique
check_PK(){
    grep -q "^$1:" "$table_data" && echo "The primary key must be unique" && return 1 || return 0
}


