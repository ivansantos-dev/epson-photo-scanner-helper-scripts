#!/bin/bash

# Check input arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 input_dir sequence"
    exit 1
fi

input_dir=$1
sequence=$2

# Check if the input directory exists
if [[ ! -d "$input_dir" ]]; then
    echo "Error: Input directory does not exist."
    exit 1
fi

output_dir="${input_dir}-output"

# Create output directory if it doesn't exist
mkdir -p $output_dir

# Function to copy and rename files
copy_and_rename() {
    local start=$1
    local end=$2
    local counter=$end
    echo range:$start-$end
    for (( i=start; i<=end; i++ )); do
        num=$(printf "%04d" $i)
        for file in "$input_dir"/*"_$num"_*.jpg "$input_dir"/*"_$num".jpg; do
            echo processing:$file
            # Continue if file doesn't exist
            [[ -e $file ]] || continue

            # Construct new filename
            base=$(basename "$file")
            sequence="${base#*_}"
            sequence="${sequence%%_*}"
            variant="${base#*_$sequence}"
            echo var1:$variant
            variant="${variant%.jpg}"
            echo var2:$variant
            prefix="${base%%_*}"
            echo prefix:$prefix

            new_file="${prefix}_$(printf "%04d" $counter)${variant}.jpg"

            echo "copying $base -> $new_file"
            cp "$file" "$output_dir/$new_file"
        done
        counter=$((counter-1))
    done
}

# Iterate over the sequences
IFS=',' read -ra seq <<< "$sequence"
for i in "${seq[@]}"; do
    IFS='-' read -ra range <<< "$i"
    copy_and_rename "${range[0]}" "${range[1]}"
done

echo "Files copied and renamed in $output_dir"

