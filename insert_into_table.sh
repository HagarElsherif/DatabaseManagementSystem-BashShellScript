#!/bin/bash






# Prompt for table name
echo ""
read -p "Enter the name of the table: " table_name
table_file="$DB_DIR/${table_name}_metadata.txt"

if [ ! -f "$table_file" ] ;then
    echo -e "Table is not found"
    return
fi 



table_file_data="$DB_DIR/$table_name.txt"
touch $table_file_data

cols_num=$(sed -n '2p' "$table_file")
cols_names=$(sed -n '3,$p' "$table_file" | cut -d: -f1)
cols_data_types=$(sed -n '3,$p' "$table_file" | cut -d: -f2)

# Convert cols_names and cols_data_types to arrays
readarray -t cols_names_array <<< "$cols_names"
readarray -t cols_data_types_array <<< "$cols_data_types"

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

check_PK(){
    awk -v value=$1 '
	BEGIN{
		FS=":"
	}
	{
		if( $1 == value ){
            print "The primary key must be unique"
            exit 1 
        }
	}
	END{}
' $table_file_data
}

new_data=""
for ((i=0; i<cols_num; i++)); do
    field=${cols_names_array[i]}
    data_type=${cols_data_types_array[i]}
    
    while true ;do

    echo ""
    read -p "Enter a value for the $field : " value
        if [ "$i" -eq 0 ] ;then
           check_PK $value || continue
        fi

        if [ $data_type = 'int' ] ;then
           check_int $value && break
        else 
           check_string $value && break
        fi
    done


    new_data+="$value:"

done

new_data=${new_data::-1}
echo $new_data >> $table_file_data




