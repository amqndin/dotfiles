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
            git -C ~/dotfiles diff
        case '*'
            echo "usage: dots (apply|remove|push|pull|status|diff)" >&2
            return 1
    end
end

