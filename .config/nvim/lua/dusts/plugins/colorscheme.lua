return {
	{
		-- "catppuccin/nvim",
		-- "dzfrias/noir.nvim",
		"sblauen/chalk",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- require("catppuccin").setup({
			-- flavour = "mocha", -- latte, frappe, macchiato, mocha
			-- })
			-- vim.cmd.colorscheme("noir")
			vim.cmd.colorscheme("chalk")
		end,
	},
}
