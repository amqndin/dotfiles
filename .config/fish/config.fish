if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_config theme choose "Catppuccin Mocha"

alias nv="nvim"
alias cat="bat"
alias grep="rg"
alias cava-mic="cava -p ~/.config/cava/config_mic"
alias refish="source ~/.config/fish/config.fish"
alias cp="cp -iv"
alias mv="mv -iv"
alias ls="eza --icons --color=always --group-directories-first"

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function cdn
    mkdir -p $argv[1]; and cd $argv[1]
end

set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

starship init fish | source
zoxide init fish --cmd cd | source
