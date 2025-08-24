if not giv rev-parse --is-inside-work-tree >/dev/null 2>&1
  echo "Error: Not in a repo"
  exit 1
end

if not git diff-index --quiet --cached HEAD
  echo "Staged changes detected. Committing staged changes only."
else
  if test (git status --porcelain | wc -l) -eq 0
    echo "No changes to commit"
    exit 0
  end
  
  echo "No staged changes detected. Staging all changes and committing."
  git add .
end

set -l status_output (git status --porcelain)

set -l added_files
set -l modified_files
set -l deleted_files
set -l renamed_files

for line in $status_output
  set -l staged_status (string sub --length 1 $line)
  set -l file_path (string sub --start 4 $line)

  switch $staged_status
    case 'A'
      set added_files $added_files $file_path
    case 'M'
      set modified_files $modified_files $file_path
    case 'D'
      set deleted_files $deleted_files $file_path
    case 'R'
      # For renamed files, get the new path
      set -l new_path (echo $file_path | string split ' -> ' | string sub --start 2)
      set renamed_files $renamed_files $new_path
  end
end

set -l commit_message ""
set -l has_changes false

if test (count $added_files) -gt 0
  set commit_message "$commit_message Added:"
  for file in $added_files
    set commit_message "$commit_message $file"
  end
  set has_changes true
end

if test (count $modified_files) -gt 0
  set commit_message "$commit_message Modified:"
  for file in $modified_files
    set commit_message "$commit_message $file"
  end
  set has_changes true
end

if test (count $deleted_files) -gt 0
  set commit_message "$commit_message Deleted:"
  for file in $deleted_files
    set commit_message "$commit_message $file"
  end
  set has_changes true
end

if test (count $renamed_files) -gt 0
  set commit_message "$commit_message Renamed:"
  for file in $renamed_files
    set commit_message "$commit_message $file"
  end
  set has_changes true
end

if $has_changes
  echo "Committing with message:"
  echo "$commit_message"
  git commit -m "$commit_message"
  echo "Commit successful."
else
  echo "No changes were staged to commit."
end
