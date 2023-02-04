#!/bin/bash

while getopts "f:ro:" opt; do
  case $opt in
    f)
      folder="$OPTARG"
      ;;
    r)
      recursive=true
      ;;
    o)
      output_dir="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ -z "$folder" ]; then
  echo "Error: the required argument -f for folder is missing." >&2
  exit 1
fi

if [ -z "$output_dir" ]; then
  output_dir="output/"
fi

if [ ! -d "$output_dir" ]; then
  echo "Output directory does not exist. Creating it..."
  mkdir -p "$output_dir"
fi

if [ -n "$recursive" ]; then
  echo "Running script in recursive mode."
  find "$folder" -type f -name "*_a.jpg" -exec cp {} "$output_dir" \;
else
  echo "Running script in non-recursive mode."
  cp "$folder"/*_a.jpg "$output_dir"
fi

