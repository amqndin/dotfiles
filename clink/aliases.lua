local aliases = {
	nv = "neovide $*",
	e = "explorer $*",
	y = "{{yazi_wrapper_path}}"
}

for alias, command in pairs(aliases) do
	os.execute("doskey " .. alias .. "=" .. command)
end

os.execute("clear && fastfetch")
