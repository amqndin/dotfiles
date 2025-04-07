local function get_full_path(relative_path)
	local full_path = debug.getinfo(1, "S").source:sub(2):match("(.*\\)") or ""
	return full_path .. relative_path
end

local aliases = {
	nv = "neovide $*",
	e = "explorer $*",
	y = get_full_path("y.cmd") .. " $*",
}

for alias, command in pairs(aliases) do
	os.execute("doskey " .. alias .. "=" .. command)
end

os.execute("clear && fastfetch")
