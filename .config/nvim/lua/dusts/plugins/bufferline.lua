return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "buffers",
			separator_style = "slant",
		},
		highlights = {
			fill = {
				-- The "all tabs" contrasting background
				-- Matches Terminal Background
				bg = "#29262f",
			},
			buffer_selected = {
				-- Color of Selected "Tab"
				-- I'm matching it to the neovim buffer background color
				bg = "#262626",
				bold = true,
				italic = true,
			},
			separator_selected = {
				-- The Slant contrasting background; it's the "bg"
				-- Matches Terminal Background for selected "Tab"
				fg = "#29262f",
				-- Adds Color to "Slant Shape" of "Tab"; it's the "fg"
				bg = "#262626",
			},
			close_button_selected = {
				-- Color of Selected "Tab" background for "Close" button
				bg = "#262626",
			},
			modified_selected = {
				-- Color of Selected "Tab" background for "Modified" indicator
				bg = "#262626",
			},
			separator_visible = {
				-- Matches Terminal Background for unselected "Tab"
				fg = "#29262f",
			},
			separator = {
				-- The Slant contrasting background; it's the "bg"
				-- Matches Terminal Background for unselected "Tab"
				fg = "#29262f",
			},
		},
	},
}
