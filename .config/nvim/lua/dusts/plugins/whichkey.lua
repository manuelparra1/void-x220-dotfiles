return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		-- Define your custom labels here
		spec = {
			{ "<leader>m", group = "Markdown/AI" }, -- Names the 'm' menu
			{ "<leader>ms", group = "Strippers" }, -- Names the 'ms' sub-menu
			{ "<leader>n", group = "AI Notes" }, -- Useful for your LLM bindings
			{ "<leader>t", group = "Tools/AI" }, -- Useful for Typora/LLM bindings
		},
	},
}
