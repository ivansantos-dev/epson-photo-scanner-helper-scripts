# EPSON Photos Organizer
This is a set of shell scripts that helps to organizer photos.

## Scripts

```bash
bash merge-scans.sh -f <first-folder> -s <second_folder -g <new group> -o <optional output directory> 
# This scripts copies pictures from first folder and second folder, and copies to output_directory using the grouping
```

```bash
bash extract_enhanced_photos.sh -f ~/Desktop/1911 -r  -o <optional output directory> 
# This scripts only copies files that contains _a.jpg to the output_directory. '-r' recursively goes through the copies
```
