#!/bin/bash
# Description: Parses a zoom transcript and returns a file that:
# 1. Removes time stamps
# 2. Concatenates the lines that a speaker says if they are consecutive,
# but transcribed separately

# Usage: ./transcript_filter.sh <filename>

INPUT_FILE=$1
OUTPUT_FILE="${INPUT_FILE%.txt}.out.txt"

# Check for filename after the command
if [[ -z "$INPUT_FILE" ]]; then
  echo
  echo "Please enter a filename after the command."
  echo "Example:"
  echo
  echo "./transcript_filter.sh my_transcript.txt"
  echo
  exit 1
fi

# Check if filename has spaces or two arguments given
if [[ -n "$2" ]]; then
  echo
  echo "You supplied more than one filename argument."
  echo "If the filename has spaces, please use quotes:"
  echo
  echo './transcript_filter.sh "Presentation with spaces.txt"'
  echo
  echo "Or manually escape spaces:"
  echo
  echo "./transcript_filter.sh Presentation\\ with\\ spaces.txt"
  echo
  exit 1
fi

# Check if the filename represents a file
if [[ ! -f "$INPUT_FILE" ]]; then
  echo
  echo "Error: File '$INPUT_FILE' does not exist or is not a regular file."
  echo
  exit 1
fi

# Remove time stamps
tmp=$(mktemp /tmp/input_transcript.XXXXXX)
trap 'rm -f "$tmp"' EXIT

sed -E 's/^(\[[^]]+\]) [0-2][0-9]:[0-5][0-9]:[0-5][0-9]$/\1/' "$INPUT_FILE" > "$tmp"

# Truncate output file from prior runs
: > "$OUTPUT_FILE"

# Squash text for each speaker
CURRENT_SPEAKER=""
while IFS= read -r line; do
  # Skip blank lines
  [[ -z "${line//[[:space:]]/}" ]] && continue

  # Process text
  if [[ $line =~ ^\[.*\]$ ]]; then
    SPEAKER=$line
    if [[ "$SPEAKER" != "$CURRENT_SPEAKER" ]]; then
       # if not the very first block, terminate previous line and add a blank line
       if [[ -n "$CURRENT_SPEAKER" ]]; then
         printf "\n\n" >> "$OUTPUT_FILE"
       fi
       echo "$SPEAKER" >> "$OUTPUT_FILE"
       CURRENT_SPEAKER=$SPEAKER
    fi
  else
    printf "%s" "$line " >> "$OUTPUT_FILE"
  fi
done < "$tmp"

echo "Success! Output saved to $OUTPUT_FILE"
