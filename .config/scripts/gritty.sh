#!/usr/bin/env bash

# Get the status of the repository using git status --porcelain
if ! git_status=$(git status --porcelain -z) || [ -z "$git_status" ]; then
  echo "No changes to stage."
  exit 0
fi

# Use fzf to select files with a preview of git diff
selected_files=$(git status --porcelain -z | fzf --multi --read0 \
  --bind 'ctrl-a:toggle-all' \
  --preview='git diff --color -- "$(echo {} | cut -c4-)"' \
  --header=$'TAB to select/deselect, Enter to stage/unstage Ctrl-a select all.\n')

# Check if any files were selected
if [ -z "$selected_files" ]; then
  echo "No files selected."
  exit 0
fi

# Extract file paths
while IFS= read -r file; do
  file="${file:3}" # Remove the status flags from the beginning of the line
  if git diff --cached --quiet "$file"; then
    git add "$file"
    echo "Staged: $file"
  else
    git restore --staged "$file"
    echo "Unstaged: $file"
  fi
done <<<"$selected_files"
