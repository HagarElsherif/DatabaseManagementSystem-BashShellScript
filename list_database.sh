#!/bin/bash

DB_DIR="dbms"

if [ -d "$DB_DIR" ]; then
    if [ -z "$(ls -A "$DB_DIR")" ]; then
        echo "There is no database"
    else
        for db in "$DB_DIR"/*; do
            echo "$(basename "$db")"
        done
    fi
else
    echo "There is no database"
fi
