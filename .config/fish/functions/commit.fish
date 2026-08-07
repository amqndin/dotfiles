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
    set msg (git diff --cached --name-status --no-renames | string replace -r '^M\s+' 'modified:' | string replace -r '^D\s+' 'deleted:' | string replace -r '^A\s+' 'added:' | string join ' ')
    if test -z "$msg"
        echo "nothing to commit" >&2
        return 1
    end
    git commit -m "$msg"
end
