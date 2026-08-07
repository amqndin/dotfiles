function dots
    if test (count $argv) -eq 0
        echo "usage: dots (apply|remove|push|pull|status|diff)" >&2
        return 1
    end
    switch $argv[1]
        case apply
            stor -f -R ~/dotfiles -t ~
        case remove
            stor -D ~/dotfiles -t ~
        case push
            set -l _dots_cwd (pwd)
            cd ~/dotfiles
            and commit
            and git push
            set -l _dots_status $status
            cd $_dots_cwd
            return $_dots_status
        case pull
            git -C ~/dotfiles pull
        case status
            git -C ~/dotfiles status
        case diff
            dots_diff
        case '*'
            echo "usage: dots (apply|remove|push|pull|status|diff)" >&2
            return 1
    end
end

function dots_diff
    set -l root "$HOME/dotfiles"
    set -l ignores stor.toml .gitignore .stowrc README.md scripts wallpaper
    set -l drifts
    for rel in (git -C "$root" ls-files)
        set -l top (string split -m1 / -- $rel)[1]
        if contains -- $top $ignores
            continue
        end
        set -l home_path "$HOME/$rel"
        if test -L "$home_path"
            set -l target (readlink "$home_path")
            if test "$target" != "$root/$rel"
                set -a drifts "wrong-link: $home_path -> $target (want $root/$rel)"
            end
        else if test -e "$home_path"
            if not cmp -s "$home_path" "$root/$rel"
                set -a drifts "drifted: $home_path differs from $root/$rel"
            end
        else
            set -a drifts "missing: $home_path"
        end
    end
    if test (count $drifts) -eq 0
        echo "clean: dotfiles projected correctly"
        return 0
    end
    printf '%s\n' $drifts
    return 1
end
