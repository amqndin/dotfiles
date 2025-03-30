local aliases = {
	nv = "neovide $*",
	e = "explorer $*",
}

for alias, command in pairs(aliases) do
	os.execute("doskey " .. alias .. "=" .. command)
end
