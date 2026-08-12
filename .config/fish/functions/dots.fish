function dots
    if test (count $argv) -eq 0
        echo "usage: dots (apply|remove|push|pull|status|diff|git|noctalia-sync)" >&2
        return 1
    end
    switch $argv[1]
        case noctalia-sync
            set -l _tmp (mktemp)
            noctalia config export merged > $_tmp
            if test -s $_tmp
                cp $_tmp ~/dotfiles/.config/noctalia/config.toml
                rm -f ~/.local/state/noctalia/settings.toml
            end
            rm -f $_tmp
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
            git -C ~/dotfiles diff
        case git
            lazygit -p ~/dotfiles
        case '*'
            echo "usage: dots (apply|remove|push|pull|status|diff|git|noctalia-sync)" >&2
            return 1
    end
end

