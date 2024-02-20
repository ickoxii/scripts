#!/opt/homebrew/bin/bash

#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <chapter_number> <number_of_sections>"
    exit 1
fi

chapter_number=$1
number_of_sections=$2

for ((i = 1; i <= $number_of_sections; i++)); do
    filename="$chapter_number-$i.md"
    echo "# $chapter_number.$i" > "$filename"
    echo "[toc](./README.md) [next]($chapter_number-$(($i + 1)).md)" >> "$filename"
done

# Update the last section's "next" link to point to README.md
last_filename="$chapter_number-$number_of_sections.md"
echo "[toc](./README.md)" > "$last_filename"
