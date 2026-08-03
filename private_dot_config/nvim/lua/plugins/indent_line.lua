-- Add indentation guides even on blank lines

---@module 'lazy'
---@type LazySpec
return {
	{

		'lukas-reineke/indent-blankline.nvim',
		-- See `:help ibl`
		event = { "BufReadPost", "BufNewFile" },
		main = 'ibl',
		---@module 'ibl'
		---@type ibl.config
		opts = {},
	},

	{
		'NMAC427/guess-indent.nvim',
		event = { "BufReadPost", "BufNewFile" },
		opts = {}
	},
}
