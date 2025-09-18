if status is-interactive
  # Commands to run in interactive sessions can go here
end

fish_config theme choose "Catppuccin Mocha"

alias nv="nvim"
alias cat="bat"
alias grep="rg"
alias cava-mic="cava -p ~/.config/cava/config_mic"
alias refish="source ~/.config/fish/config.fish"
alias cp="cp -i"
alias mv="mv -i"
alias ls="eza --icons --color=always --group-directories-first"

function man
    command man $argv | nvim -c "se syn=man"
end

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

# set -gx ELECTRON_OZONE_PLATFORM_HINT "auto"
# set -gx DISPLAY ":1"
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx QT_QPA_PLATFORMTHEME "kde"
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"
set -gx BROWSER "zen-browser"
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#89B4FA,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#89B4FA,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

starship init fish | source
zoxide init fish --cmd cd | source
fzf --fish | source
thefuck --alias | source
