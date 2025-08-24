#
# A fish script for automatically committing changes in a git repository.
#
# This script first checks if there are any staged changes.
# - If staged changes exist, it commits only those changes.
# - If no staged changes exist, it stages all changes and then commits them.
#
# The commit message is automatically generated based on the files being committed.
#
# Usage:
# 1. Save this file as 'git-commit-auto.fish' or a similar name.
# 2. Make it executable: 'chmod +x git-commit-auto.fish'
# 3. Place it in your PATH, or add it as a function in your fish config.
# 4. Run it in a git repository: './git-commit-auto.fish'
#
# Note: When no staged files are found, this script will stage ALL untracked
# and modified files. Use with caution!
#

# Check if we are inside a git repository
if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
    echo "Error: Not a git repository."
    exit 1
end

# Check for staged changes. `git diff-index` exits with 1 if there are differences.
if not git diff-index --quiet --cached HEAD
    # Staged changes exist. Do not stage new files.
    echo "Staged changes detected. Committing staged changes only."
else
    # No staged changes found.
    # Check if there are any unstaged or untracked files to stage.
    if test (git status --porcelain | wc -l) -eq 0
        echo "No changes to commit (neither staged nor unstaged)."
        exit 0
    end

    echo "No staged changes detected. Staging all changes and committing."
    git add .
end

# --- Build the commit message from the staged files ---
# We use `git status --porcelain` which shows the staged status in the first column.
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

# Build the commit message string
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

# Make the commit
if $has_changes
    echo "Committing with message:"
    echo "$commit_message"
    git commit -m "$commit_message"
    echo "Commit successful."
else
    # This case should be rare, but handles edge cases where `git add .`
    # didn't stage anything.
    echo "No changes were staged to commit."
end
