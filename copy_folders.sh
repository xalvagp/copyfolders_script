#!/bin/bash

################################################################################
# copy_folders.sh
#
# Copies folders from a source directory to a target directory.
# Only folders that do not exist in the target directory are copied.
# Copies in batches of up to 5 folders at a time.
#
# Usage:
#   ./copy_folders.sh /path/to/source_folder /path/to/target_folder [num_folders]
#
# Notes:
# - Handles folder names with spaces and special characters safely.
# - Requires bash shell.
#
# Acknowledgments:
# This script was created with assistance from the Perplexity AI assistant.
# Many thanks for the support in writing and refining this script.
################################################################################

usage() {
  echo "Usage: $0 source_folder target_folder [num_folders]"
  echo "  source_folder: The directory to copy folders from."
  echo "  target_folder: The directory to copy folders to."
  echo "  num_folders (optional): The number of folders to copy in each batch (default: 5)."
  exit 1
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  usage
fi

source_folder="$1"
target_folder="$2"
num_folders=${3:-5} # Default to 5 if not provided

# Validate that num_folders is a positive integer
if ! [[ "$num_folders" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: Number of folders must be a positive integer."
  exit 1
fi

# Check if source and target folders exist
if [ ! -d "$source_folder" ]; then
  echo "Error: Source folder does not exist: '$source_folder'"
  exit 1
fi

if [ ! -d "$target_folder" ]; then
  echo "Error: Target folder does not exist: '$target_folder'"
  exit 1
fi

echo "Starting copy from: '$source_folder'"
echo "Copying to: '$target_folder'"

batch=()

copy_batch() {
  if [ ${#batch[@]} -gt 0 ]; then
    echo "Copying folders:"

    # Print each folder basename individually for clarity
    for f in "${batch[@]}"; do
      echo "  - $(basename "$f")"
    done

    # Perform the copy
    cp -r "${batch[@]}" "$target_folder"
    if [ "$?" -ne 0 ]; then
      echo "Error: Copy command failed."
      exit 1
    fi

    batch=()
  fi
}

# Iterate over folders in the source folder
shopt -s nullglob
for folder in "$source_folder"/*/; do
  if [ -d "$folder" ]; then
    folder_name=$(basename "$folder")
    if [ ! -d "$target_folder/$folder_name" ]; then
      echo "Adding folder to batch: '$folder_name'"
      batch+=("$folder")
    else
      echo "Skipping existing folder: '$folder_name'"
    fi
  fi

    if [ ${#batch[@]} -eq "$num_folders" ]; then
    copy_batch
  fi
done
shopt -u nullglob

# Copy any remaining folders
copy_batch

echo "Copying completed."

