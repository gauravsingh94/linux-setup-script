#!/bin/bash

# Set the source directory for screenshots
source_dir="/home/gaurav/Pictures/Screenshots/"

# Ensure the destination directory exists
destination_dir="${source_dir}old/"
mkdir -p "$destination_dir"

# Move screenshots to their respective folders
for screenshot in "$source_dir"Screenshot*; do
    if [ -f "$screenshot" ]; then
        # Get the creation date of the screenshot
        creation_date=$(date -r "$screenshot" "+%d-%m-%Y")
        
        # Create a folder for the screenshot based on the creation date
        folder_name="${destination_dir}${creation_date}/"
        mkdir -p "$folder_name"
        
        # Move the screenshot to the appropriate folder
        mv "$screenshot" "$folder_name"
    fi
done

echo "Screenshots have been organized."
