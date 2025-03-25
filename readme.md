# Bash Shell Script Database Management System (DBMS)

## Project Overview

The **Bash Shell Script Database Management System (DBMS)** is a command-line interface (CLI) application that enables users to store and retrieve data from a hard disk using a simple file-based approach. The system provides fundamental database operations, allowing users to manage databases and tables efficiently.

## Features

The application is menu-driven and provides the following functionalities:

### **Main Menu**

- **Create Database** - Allows users to create a new database.
- **List Databases** - Displays a list of all available databases.
- **Connect to Database** - Enables users to select and work with a specific database.
- **Drop Database** - Deletes a selected database and its contents.

### **Database Operations Menu (Upon Connecting to a Database)**

- **Create Table** - Allows users to define a new table with column names and data types.
- **List Tables** - Displays all tables in the current database.
- **Drop Table** - Deletes a selected table.
- **Insert into Table** - Adds a new record to a table while validating data types and primary key constraints.
- **Select from Table** - Retrieves and displays table records in a structured format.
- **Delete from Table** - Removes specific records from a table.
- **Update Table** - Modifies existing records while ensuring data type consistency.

## Hints & Implementation Details

- Each database is stored as a **directory** within the script’s working directory.
- Each table is stored as a **file** inside its corresponding database directory.
- When selecting rows, data is displayed in a structured, readable format.
- During **table creation**, users must specify column names, data types, and a primary key.
- When inserting or updating records, data type validation is enforced, ensuring consistency.
- The system checks for **unique primary key constraints** before allowing new records.

## Technologies Used

- **Bash Shell Scripting** for building the CLI application.
- **File System (Directories & Text Files)** for database and table storage.
- **Standard Linux Commands** for handling file operations efficiently.

## How to Run

1. Clone the repository or copy the script file.
2. Open a terminal and navigate to the script’s directory.
3. Run the script using:
   ```bash
   chmod +x main_menu.sh
   ./main_menu.sh
   ```
4. Follow the on-screen menu prompts to interact with the database system.


## Contributors

- Hagar Mohamed Elsherif
- Nayra Ashraf Hamdy

## License

This project is licensed under the MIT License.

