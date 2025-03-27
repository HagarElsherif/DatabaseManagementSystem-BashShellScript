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

# check_PK(){
#     awk -v value=$1 '
# 	BEGIN{
# 		FS=":"
# 	}
# 	{
# 		if( $1 == value ){
#             print "The primary key must be unique"
#             exit 1 
#         }
# 	}
# 	END{}
# ' $table_file_data
# }

# Function to ensure Primary Key is unique
check_PK(){
    grep -q "^$1:" "$table_data" && echo "The primary key must be unique" && return 1 || return 0
}


