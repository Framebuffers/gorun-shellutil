#!/bin/bash
# gorun-shellutil
# (C) 2024 Framebuffer. Licenced under the MIT licence. See LICENSE for details.
#
# (very simple) script that automates the work of making go files executable with gorun
# this enables gorun to work just by passing the file as an argument.

file="$1"
line='/// 2>/dev/null ; gorun "$0" "$@" ; exit $?'

echo -e "Automatic gorun utility."
echo -e "Makes go files executable using gorun and prompts to run them directly."
echo -e "\n1. Adding shebang to $file as comment."

# take go file as input
if [ -z "$1" ]; then
  echo -e "Usage: $0 <file.go>"
  exit 1
fi

# check if shebang is present
if ! grep -qF "$line" "$file"; then
  echo -e "\tLine not present, prepending gorun comment to make go $file executable."
  # if not, prepend shebang
  echo -e -e "$line\n$(cat "$file")" > "$file"
else
  echo -e "\tLine already present. File is ready"
fi

# make file executable
echo -e "\n2. Running chmod +x to make file executable."
if [ -x "$file" ]; then
  echo -e "\t$file is now executable, now it can be run directly!"
else
  echo -e "\t$file not executable. Running chmod +x"
  chmod +x "$file"
fi

# ask to run directly
echo -e "\n3. File is ready!"
echo -e "\tWant to run $file now?"
read -rep "Choose (y/n): " choice
if [ "$choice" = "y" ]; then
  ./"$file"
else
  echo -e "\n$file is now executable. You can run it later as ./$file"
fi

