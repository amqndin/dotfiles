function commit
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "not a git repo" >&2
        return 1
    end
    if not git diff --cached --quiet
        set --append add_flags
    else
        git add -A
    end
    set -l added_list
    set -l modified_list
    set -l deleted_list
    for line in (git diff --cached --name-status --no-renames)
        set -l status (string sub -l 1 -- $line)
        set -l path (string replace -r '^[AMD]\s+' '' -- $line)
        switch $status
            case A
                set -a added_list $path
            case M
                set -a modified_list $path
            case D
                set -a deleted_list $path
        end
    end
    set -l parts
    if test (count $added_list) -gt 0
        set -a parts "added:" $added_list
    end
    if test (count $modified_list) -gt 0
        set -a parts "modified:" $modified_list
    end
    if test (count $deleted_list) -gt 0
        set -a parts "deleted:" $deleted_list
    end
    if test (count $parts) -eq 0
        echo "nothing to commit" >&2
        return 1
    end
    git commit -m (string join ' ' -- $parts)
end
