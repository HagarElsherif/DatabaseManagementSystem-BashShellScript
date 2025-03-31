#!/bin/bash
main_menu() {
    while true; do
        echo -e "\e[93m" 
        echo -e "\n1) Create DataBase\n2) Delete DataBase\n3) Connect DataBase\n4) List DataBases\n5) Exit the program"
        echo -e "\e[0m" 

        echo -e "\e[35m" 
        read -r -p "Enter your choice number: " option
        echo -e "\e[0m" 
            case $option in
                5)
                    echo "Exiting the program. Goodbye!"
                    exit
                    ;;
                1)
                    ./create_database.sh
                    ;;
                2)
                    ./delete_database.sh
                    ;;
                3)
                    . ./connect_database.sh
                    ;;
                4)
                    ./list_database.sh
                    ;;
                *)
                    echo -e "\e[31m" 
                    echo "Invalid Option: Please choose an option from the menu."
                    echo -e "\e[0m" 
                    ;;
                    
            esac
    done
}

main_menu
