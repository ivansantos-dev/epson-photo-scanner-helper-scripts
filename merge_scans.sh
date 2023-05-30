#!/bin/bash

# Check input arguments
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 grouping_word output_dir merge_dir1,merge_dir2"
    exit 1
fi

grouping_word=$1
input_output_dir="$2"
dirs=$3
output_dir="${input_output_dir}/${grouping_word}-merge-output"

# Create output directory if it doesn't exist
mkdir -p $output_dir

# Initialize counter
counter=0

# Function to copy and rename files
copy_and_rename() {
    local dir=$1
    local current_seq=""

    # Get a sorted list of files, grouped by sequence number
    files=$(find "$dir" -type f \( -iname "*_????.jpg" -o -iname "*_????_*.jpg" \) | sort -t '_' -k2,2n)

    # Read files line by line
    while IFS= read -r file
    do

        # Continue if file doesn't exist
        [[ -e $file ]] || continue

        # Construct new filename
        base=$(basename "$file")
        prefix="${base%%_*}"
        sequence="${base#*_}"
        sequence="${sequence%%_*}"
        variant="${base#*_$sequence}"
        variant="${variant%.jpg}"

        actual_sequence=${sequence%.jpg}
        if [[ "$actual_sequence" != "$current_seq" ]]; then
            current_seq="$actual_sequence"
            counter=$((counter+1))
        fi

        new_file="${grouping_word}_$(printf "%04d" $counter)${variant}.jpg"
        echo "copy $file -> $output_dir/$new_file"
        cp "$file" "$output_dir/$new_file"
    done <<< "$files"
}

# Iterate over the directories
IFS=',' read -ra dir_list <<< "$dirs"
for dir in "${dir_list[@]}"; do
    dir=$(eval echo "$dir")
    if [[ -d "$dir" ]]; then
        copy_and_rename "$dir"
    else
        echo "Warning: $dir does not exist or is not a directory."
    fi
done

echo "Files copied and renamed in $output_dir"

