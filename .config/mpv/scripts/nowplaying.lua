mp.register_event("file-loaded", function()
	local function get_tag(tag)
		return mp.get_property("metadata/by-key/" .. tag, "Unknown")
	end

	local msg = string.format(
		" Artist: %s\n Album: %s\n Date: %s\n Genre: %s\n Title: %s\n Track: %s\n",
		get_tag("Artist"),
		get_tag("Album"),
		get_tag("Date"),
		get_tag("Genre"),
		get_tag("Title"),
		get_tag("Track")
	)

	-- Bypass mpv's logger and print directly to the terminal
	io.stdout:write(msg)
	io.stdout:flush()
end)
