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
    set msg (git diff --cached --name-status | string replace -r '^M' 'modified:' | string replace -r '^D' 'deleted:' | string replace -r '^A' 'added:' | string replace -r '^R' 'renamed:' | string join ' ')
    if test -z "$msg"
        echo "nothing to commit" >&2
        return 1
    end
    git commit -m "$msg"
end
