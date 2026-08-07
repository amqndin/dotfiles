function dots
    if test (count $argv) -eq 0
        echo "usage: dots (apply|push|pull)" >&2
        return 1
    end
    switch $argv[1]
        case apply
            stor -f -R ~/dotfiles -t ~
        case push
            cd ~/dotfiles
            and commit
            and git push
        case pull
            git -C ~/dotfiles pull
        case '*'
            echo "usage: dots (apply|push|pull)" >&2
            return 1
    end
end
