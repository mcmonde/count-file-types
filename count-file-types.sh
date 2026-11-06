#!/bin/bash

DIRECTORY="${1:-.}"

if [ ! -d "$DIRECTORY" ]; then
    echo "Error: '$DIRECTORY' is not a directory."
    exit 1
fi

echo "Scanning: $DIRECTORY"
echo "Please wait..."
echo

find "$DIRECTORY" -type f -print0 |
awk -v RS='\0' '
{
    total++

    n = split($0, parts, "/")
    filename = parts[n]

    if (filename ~ /^\.[^.]+$/ || filename !~ /\./) {
        ext = "[no extension]"
    } else {
        sub(/^.*\./, "", filename)
        ext = "." tolower(filename)
    }

    count[ext]++
}
END {
    print "================================"
    print "Total files: " total
    print "================================"
    print ""

    for (ext in count)
        print count[ext], ext
}
' | sort -nr
