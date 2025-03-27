#!/bin/bash
main_menu() {
    while true; do
        echo -e "\n1) Create DataBase\n2) Delete DataBase\n3) Connect DataBase\n4) List DataBases\n5) Exit the program"
        read -p "Enter your choice number: " option
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
                    echo "Invalid Option: Please choose an option from the menu."
                    ;;
            esac
    done
}

main_menu
