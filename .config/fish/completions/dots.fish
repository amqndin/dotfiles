complete -c dots -f
complete -c dots -n "__fish_use_subcommand" -a apply -d "Apply dotfiles"
complete -c dots -n "__fish_use_subcommand" -a remove -d "Remove dotfiles"
complete -c dots -n "__fish_use_subcommand" -a push -d "Commit and push dotfiles"
complete -c dots -n "__fish_use_subcommand" -a pull -d "Pull dotfiles"
complete -c dots -n "__fish_use_subcommand" -a status -d "Git status of dotfiles"
complete -c dots -n "__fish_use_subcommand" -a diff -d "Git diff of dotfiles"
complete -c dots -n "__fish_use_subcommand" -a git -d "Launch lazygit for dotfiles"
complete -c dots -n "__fish_use_subcommand" -a noctalia-sync -d "Export merged noctalia config"
