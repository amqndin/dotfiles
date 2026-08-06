function push-dots
    chezmoi re-add
    chezmoi git add -A
    set -l diff (chezmoi git diff --cached --name-only 2>/dev/null)
    if test -n "$diff"
        chezmoi git commit -m "Update dotfiles"
        chezmoi git push
    else
        echo "nothing to push"
    end
end
