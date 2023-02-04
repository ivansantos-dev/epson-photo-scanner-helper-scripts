#!/bin/bash

while getopts f:s:g:o: flag
do
    case "${flag}" in
        f) f1=${OPTARG};;
        s) f2=${OPTARG};;
        g) new_grouping=${OPTARG};;
        o) output_folder=${OPTARG};;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :)  echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

echo "First folder: $f1";
echo "Second folder: $f2";
echo "New Grouping name: $new_grouping";

if [ ! -n "$output_folder" ] ;then 
    output_folder="output"
fi

output_dir="$output_folder/$new_grouping"
echo "Output Dir": $output_dir;


if [ -z "$f1" ] || [ -z "$f2" ] || [ -z "$new_grouping" ]; then
    echo "Usage: $0 -f first_folder -s second_folder -g new_grouping -o output_dir"
    echo "Merge files from first_folder and second_folder, copy all the files to output_dir/new_grouping and rename the files in order using integers"
    exit 1
fi

# Sort all files from f1 first, then sort files from f2 and add to the sorted_files array
sorted_files=($(ls "$f1" | sort) $(ls "$f2" | sort))
echo "Sorted files: ${sorted_files[@]}"

read -p "Do you want to continue? (yes/no): " choice

if [ "$choice" == "no" ]; then
    exit 0
fi

if [ ! -d "$output_dir" ]; then
    echo "Generating output dir"
    mkdir -p "$output_dir"
fi


# Copy files to output_dir and rename in order using integers
i=1
for file in "${sorted_files[@]}"; do
    number=`printf "%04d\n" $i`

    suffix=""
    
    if [[ "${file}" == *"_a.jpg" ]]; then
        suffix="_a"
    elif [[ "${file}" == *"_b.jpg" ]]; then
        suffix="_b"
    fi

    new_file="$output_dir/${new_grouping}_${number}${suffix}.jpg"
    echo "Creating file $new_file"
    cp "$f1/$file" $new_file 2>/dev/null || cp "$f2/$file" $new_file

    if [ -z "$suffix" ]; then
         i=$((i + 1))
    fi
done
