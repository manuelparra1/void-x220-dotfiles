return {
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 68,
				options = {
					number = false,
					relativenumber = false,
					signcolumn = "no",
				},
			},
			plugins = {
				twilight = { enabled = true },
				kitty = { enabled = true, font = "+4" },
			},
		},
	},
	{
		"folke/twilight.nvim",
		opts = {
			context = 1,
		},
	},
}
