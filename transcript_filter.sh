# !/bin/bash
# Description: Parses a zoom transcript and returns a file that:
# 1. Removes time stamps
# 2. Concatenates the lines that a speaker says if they are consecutive,
# but transcribed separately

# Usage: ./transcript_filter.sh <filename>

INPUT_FILE=$1

if [[ -z "$INPUT_FILE" ]]; then
  echo
  echo "Please enter a filename after the command."
  echo "Example:"
  echo
  echo "% transcript_filter.sh my_transcript.txt"
  echo
  exit 1
fi

if [[ -n "$2" ]]; then
  echo
  echo "You supplied more than one filename argument."
  echo "If the file name has spaces, please use parentheses around filenames."
  echo "Example:"
  echo
  echo '% transcript_filter.sh "Presentation on not using spaces in filenames.txt"'
  echo
  echo "Other options are to use tab completion or manually escape blank spaces."
  echo "Example:"
  echo
  echo '% transcript_filter.sh "Presentation\ on\ not\ using\ spaces\ in\ filenames.txt"'
  echo
  exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
  echo
  echo "Error: File '$INPUT_FILE' does not exist or is not a regular file."
  echo
  exit 1
fi

echo "Success!"
