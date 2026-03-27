return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = {
		"BufReadPre /home/dusts/aston/Notes/Obsidian/aston/*.md",
		"BufNewFile /home/dusts/aston/Notes/Obsidian/aston/*.md",
		"BufReadPre /home/dusts/Github/notes/Obsidian/*.md",
		"BufNewFile /home/dusts/Github/notes/Obsidian/*.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		ui = {
			enable = false,
		},
		workspaces = {
			-- {
			-- 	name = "personal",
			-- 	path = "/home/dusts/Github/notes/Obsidian/",
			-- },
			{
				name = "work",
				path = "/home/dusts/aston/Notes/Obsidian/aston/",
			},
		},
		note_frontmatter_func = function(note)
			if note.title then
				note:add_alias(note.title)
			end
			local frontmatter = { id = note.id, aliases = note.aliases, tags = note.tags }

			-- Merge custom keys from existing frontmatter
			if note.metadata then
				for key, value in pairs(note.metadata) do
					frontmatter[key] = value
				end
			end

			-- Only add created if it doesn't exist
			if not frontmatter.created then
				frontmatter.created = os.date("%Y-%m-%dT%H:%M:%S", os.time())
			end

			return frontmatter
		end,
	},
}
