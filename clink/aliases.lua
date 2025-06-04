local function get_full_path(relative_path)
	local full_path = debug.getinfo(1, "S").source:sub(2):match("(.*\\)") or ""
	return full_path .. relative_path
end

local aliases = {
	nv = "neovide $*",
	e = "explorer $*",
	lg = "lazygit $*",
	cdi = "cdi",
	cdn = get_full_path("cdn.cmd") .. " $*",
	clear = "cowsay -f dragon \"Nuh-uh! Stop clearing the screen!\"",
	y = get_full_path("y.cmd") .. " $*",
}

for alias, command in pairs(aliases) do
	os.execute("doskey " .. alias .. "=" .. command)
end

os.execute("clear")
