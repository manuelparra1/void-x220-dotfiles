local M = {}
local Job = require("plenary.job")

-- =============================================================================
-- Local Helper Functions
-- =============================================================================

local function get_comment_syntax(ft)
	local comment_markers = {
		lua = "--",
		python = "#",
		cisco = "!",
		javascript = "//",
		typescript = "//",
		java = "//",
		cpp = "//",
		c = "//",
		rust = "//",
		go = "//",
		markdown = "",
		text = "",
	}
	local marker = comment_markers[ft]
	if marker == nil then
		marker = "#"
	end
	return marker
end

local function get_chat_prefix(ft, comment_syntax)
	local chat_token = "??>"
	if ft == "markdown" or ft == "text" or ft == "" then
		return chat_token .. " "
	end
	return comment_syntax .. " " .. chat_token .. " "
end

local function parse_buffer_chat(visual_lines, user_prefix, comment_syntax)
	local messages = {}
	local current_role = nil
	local current_content = {}
	local current_reasoning = {}
	local is_thinking = false

	local comment_prefix = comment_syntax
	if comment_prefix ~= "" then
		comment_prefix = comment_prefix .. " "
	end

	local function save_message()
		if #current_content > 0 or #current_reasoning > 0 then
			local msg = { role = current_role, content = table.concat(current_content, "\n") }
			if #current_reasoning > 0 then
				msg.reasoning = table.concat(current_reasoning, "\n")
			end
			table.insert(messages, msg)
			current_content = {}
			current_reasoning = {}
		end
	end

	for _, line in ipairs(visual_lines) do
		local trimmed_line = vim.trim(line)
		local is_user_line = vim.startswith(trimmed_line, user_prefix)

		if is_user_line and current_role ~= "user" then
			save_message()
			current_role = "user"
			is_thinking = false
		elseif not is_user_line and trimmed_line ~= "" and current_role ~= "assistant" then
			save_message()
			current_role = "assistant"
		end

		if current_role == "user" then
			local stripped_line = line:gsub("^%s*" .. vim.pesc(user_prefix), "")
			table.insert(current_content, stripped_line)
		elseif current_role == "assistant" then
			if line:match("<think>") then
				is_thinking = true
			elseif line:match("</think>") then
				is_thinking = false
			elseif is_thinking then
				local stripped_thought = line
				if comment_prefix ~= "" then
					stripped_thought = line:gsub("^%s*" .. vim.pesc(comment_prefix), "")
				end
				table.insert(current_reasoning, stripped_thought)
			else
				table.insert(current_content, line)
			end
		end
	end

	save_message()

	if #messages == 0 then
		table.insert(messages, { role = "user", content = table.concat(visual_lines, "\n") })
	end

	return messages
end

local function process_data_lines(line, process_data)
	local json = line:match("^data: (.+)$")
	if json then
		if json == "[DONE]" then
			return true
		end
		local ok, data = pcall(vim.json.decode, json)
		if ok and data then
			vim.schedule(function()
				pcall(vim.cmd, "undojoin")
				process_data(data)
			end)
		end
	end
	return false
end

local function process_sse_response(buffer, service, state)
	local comment_syntax = state.comment_syntax

	for line in string.gmatch(buffer, "[^\r\n]+") do
		process_data_lines(line, function(data)
			local raw_content = ""
			local is_reasoning_chunk = false

			-- 1. Stream Parsing with Strict Type Checking
			if service == "anthropic" then
				if data.type == "content_block_delta" and data.delta then
					if data.delta.type == "text_delta" and type(data.delta.text) == "string" then
						raw_content = data.delta.text
					elseif data.delta.type == "thinking_delta" and type(data.delta.thinking) == "string" then
						raw_content = data.delta.thinking
						is_reasoning_chunk = true
					end
				end
			else
				if data.choices and data.choices[1] and data.choices[1].delta then
					local delta = data.choices[1].delta

					if delta.reasoning_details and type(delta.reasoning_details) == "table" then
						for _, detail in ipairs(delta.reasoning_details) do
							if detail.type == "reasoning.text" and type(detail.text) == "string" then
								raw_content = raw_content .. detail.text
								is_reasoning_chunk = true
							end
						end
					elseif delta.reasoning and type(delta.reasoning) == "string" then
						raw_content = delta.reasoning
						is_reasoning_chunk = true
					elseif delta.content and type(delta.content) == "string" then
						raw_content = delta.content
					end
				end
			end

			-- Safety guard: Abort if we didn't extract a valid string
			if type(raw_content) ~= "string" or raw_content == "" then
				return
			end

			-- 2. Buffer Formatting
			local formatted_content = ""
			if not state.is_currently_thinking and is_reasoning_chunk then
				state.is_currently_thinking = true
				formatted_content = "\n"
					.. comment_syntax
					.. "<think>\n"
					.. comment_syntax
					.. raw_content:gsub("\n", "\n" .. comment_syntax)
			elseif state.is_currently_thinking and is_reasoning_chunk then
				formatted_content = raw_content:gsub("\n", "\n" .. comment_syntax)
			elseif state.is_currently_thinking and not is_reasoning_chunk then
				state.is_currently_thinking = false
				formatted_content = "\n" .. comment_syntax .. "</think>\n\n" .. raw_content
			else
				formatted_content = raw_content
			end

			-- 3. Write to Buffer
			if not state.first_chunk_received then
				state.first_chunk_received = true
				vim.api.nvim_buf_set_lines(0, state.line - 1, state.line, false, {})
				state.line = state.line - 1
			end

			local combined = (state.current_content or "") .. formatted_content
			local content_lines = vim.split(combined, "\n", { plain = true })

			vim.api.nvim_buf_set_lines(0, state.line, state.line + 1, false, { content_lines[1] })
			if #content_lines > 1 then
				for i = 2, #content_lines do
					vim.api.nvim_buf_set_lines(0, state.line + i - 1, state.line + i - 1, false, { content_lines[i] })
				end
				state.line = state.line + #content_lines - 1
				state.current_content = content_lines[#content_lines]
			else
				state.current_content = content_lines[1]
			end
			vim.api.nvim_win_set_cursor(0, { state.line + 1, #state.current_content })
		end)
	end
end

-- =============================================================================
-- Main Setup Function
-- =============================================================================
function M.setup(llm, services, prompts)
	function llm.prompt_selection_only(opts)
		local replace = opts.replace
		local service = opts.service
		local visual_lines = {}
		local mode = vim.api.nvim_get_mode().mode
		local selection_end_row

		if mode == "v" or mode == "V" or mode == "\22" then
			local start_pos = vim.fn.getpos("v")
			local end_pos = vim.fn.getpos(".")
			if start_pos[2] == 0 or end_pos[2] == 0 then
				return
			end
			if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
				start_pos, end_pos = end_pos, start_pos
			end
			selection_end_row = end_pos[2]

			if mode == "V" then
				for lnum = start_pos[2], end_pos[2] do
					table.insert(visual_lines, vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1])
				end
			else
				if start_pos[2] == end_pos[2] then
					local line = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, start_pos[2], false)[1]
					table.insert(visual_lines, string.sub(line, start_pos[3], end_pos[3]))
				else
					for lnum = start_pos[2], end_pos[2] do
						local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
						if lnum == start_pos[2] then
							table.insert(visual_lines, string.sub(line, start_pos[3]))
						elseif lnum == end_pos[2] then
							table.insert(visual_lines, string.sub(line, 1, end_pos[3]))
						else
							table.insert(visual_lines, line)
						end
					end
				end
			end
		else
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			if start_pos[2] == 0 or end_pos[2] == 0 then
				return
			end
			selection_end_row = end_pos[2]
			local success, result =
				pcall(vim.api.nvim_buf_get_text, 0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], {})
			if success then
				visual_lines = result
			end
		end

		if not visual_lines or #visual_lines == 0 then
			print("No selection found")
			return
		end

		local found_service = services[service]
		if not found_service then
			print("Invalid service: " .. service)
			return
		end

		local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		local c_syntax = get_comment_syntax(ft)
		local u_prefix = get_chat_prefix(ft, c_syntax)
		local parsed_history = parse_buffer_chat(visual_lines, u_prefix, c_syntax)

		local sse_state = {
			first_chunk_received = false,
			is_currently_thinking = false,
			current_content = "",
			line = 0,
			comment_syntax = c_syntax ~= "" and (c_syntax .. " ") or "",
		}

		if replace then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("cThinking...", true, true, true), "v", false)
			sse_state.line = vim.api.nvim_win_get_cursor(0)[1] - 1
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
			vim.defer_fn(function()
				vim.api.nvim_buf_set_lines(0, selection_end_row, selection_end_row, false, { "", "Thinking..." })
				sse_state.line = selection_end_row + 1
				vim.api.nvim_win_set_cursor(0, { sse_state.line + 1, 0 })
			end, 50)
		end

		local url = found_service.url
		local api_key_name = found_service.api_key_name
		local model = found_service.model
		local api_key = api_key_name and os.getenv(api_key_name)
		local data = {}
		local instructions = opts.system_prompt or prompts.note_system_prompt

		-- Build Payload
		if service == "anthropic" then
			data = {
				model = model,
				system = instructions,
				messages = parsed_history,
				max_tokens = opts.max_tokens or 8192,
				stream = true,
			}
			if opts.reasoning == "true" or opts.reasoning_effort then
				data.thinking = { type = "enabled", budget_tokens = 4096 }
			end
		elseif service == "mistral" or service == "ministral" or service == "nemostral" then
			data = {
				model = model,
				stream = true,
				max_tokens = opts.max_tokens,
				temperature = opts.temperature or 0.7,
				messages = { { role = "system", content = instructions } },
			}
			for _, msg in ipairs(parsed_history) do
				table.insert(data.messages, msg)
			end

			if opts.reasoning == "true" or opts.reasoning_effort then
				data.reasoning_effort = opts.reasoning_effort or "high"
			end
		else
			data = {
				model = model,
				stream = true,
				max_tokens = opts.max_tokens,
				temperature = opts.temperature or 0.7,
				messages = { { role = "system", content = instructions } },
			}
			for _, msg in ipairs(parsed_history) do
				table.insert(data.messages, msg)
			end

			-- The Unified OpenRouter Reasoning Router
			if opts.reasoning_tokens then
				-- Explicit token budget (Great for Tiny models)
				data.reasoning = { max_tokens = opts.reasoning_tokens }
			elseif opts.reasoning_effort then
				-- Explicit effort level (Great for OpenAI/Gemini)
				data.reasoning = { effort = opts.reasoning_effort }
			elseif opts.reasoning == "true" then
				-- The "Just turn it on and figure it out" fallback
				data.reasoning = { enabled = true }
			elseif opts.thinking == "off" then
				-- Force it to hide thoughts
				data.reasoning = { exclude = true }
			end
		end

		local args = {
			"-N",
			"POST",
			"-H",
			"Content-Type: application/json",
			"-d",
			vim.json.encode(data),
		}

		if api_key then
			if found_service.headers then
				for k, v in pairs(found_service.headers) do
					table.insert(args, "-H")
					table.insert(args, k .. ": " .. v)
				end
			end

			if service == "anthropic" then
				table.insert(args, "-H")
				table.insert(args, "x-api-key: " .. api_key)
				table.insert(args, "-H")
				table.insert(args, "anthropic-version: 2023-06-01")
			else
				table.insert(args, "-H")
				table.insert(args, "Authorization: Bearer " .. api_key)
			end
		end

		table.insert(args, url)

		local current_active_job = Job:new({
			command = "curl",
			args = args,
			on_stdout = function(_, out)
				if out and out ~= "" then
					process_sse_response(out, service, sse_state)
				end
			end,
			on_exit = function()
				vim.schedule(function()
					if not sse_state.first_chunk_received then
						local line_content = vim.api.nvim_buf_get_lines(0, sse_state.line, sse_state.line + 1, false)[1]
						if line_content and line_content:match("Thinking%.%.%.") then
							vim.api.nvim_buf_set_lines(
								0,
								sse_state.line,
								sse_state.line + 1,
								false,
								{ "Error receiving response." }
							)
						end
					end
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
				end)
			end,
		})
		current_active_job:start()
	end

	function llm.prompt_selection_only_append(opts)
		opts.replace = false
		llm.prompt_selection_only(opts)
	end
end

return M
