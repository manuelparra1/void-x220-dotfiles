local M = {}
local Job = require("plenary.job")

-- =============================================================================
-- Local Helper Functions
-- =============================================================================
local function write_string_at_cursor(str)
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	local pos = vim.api.nvim_win_get_cursor(win)
	local start_row, start_col = pos[1], pos[2]
	local lines = vim.split(str, "\n")
	vim.api.nvim_buf_set_text(buf, start_row - 1, start_col, start_row - 1, start_col, lines)

	local num_lines = #lines
	local end_row, end_col
	if num_lines == 1 then
		end_row = start_row
		end_col = start_col + #lines[1]
	else
		end_row = start_row + num_lines - 1
		end_col = #lines[num_lines]
	end
	vim.api.nvim_win_set_cursor(win, { end_row, end_col })
end

local function process_data_lines(line, service, process_data)
	local json = line:match("^data: (.+)$")
	if json then
		if json == "[DONE]" then
			return true
		end
		local data = vim.json.decode(json)
		vim.schedule(function()
			vim.cmd("undojoin")
			process_data(data)
		end)
	end
	return false
end

local function process_sse_response(buffer, service, state)
	for line in string.gmatch(buffer, "[^\r\n]+") do
		process_data_lines(line, service, function(data)
			local content
			if data.choices and data.choices[1] and data.choices[1].delta then
				content = data.choices[1].delta.content
			end

			if content and content ~= vim.NIL then
				if state and not state.first_chunk_received then
					state.first_chunk_received = true
					local content_lines = vim.split(content, "\n", { plain = true })
					vim.api.nvim_buf_set_lines(0, state.line - 1, state.line, false, { content_lines[1] })
					if #content_lines > 1 then
						for i = 2, #content_lines do
							vim.api.nvim_buf_set_lines(
								0,
								state.line + i - 2,
								state.line + i - 2,
								false,
								{ content_lines[i] }
							)
						end
						state.line = state.line + #content_lines - 1
						state.current_content = content_lines[#content_lines]
					else
						state.current_content = content_lines[1]
					end
					vim.api.nvim_win_set_cursor(0, { state.line, #state.current_content })
				else
					local combined = (state.current_content or "") .. content
					local content_lines = vim.split(combined, "\n", { plain = true })
					vim.api.nvim_buf_set_lines(0, state.line - 1, state.line, false, { content_lines[1] })
					if #content_lines > 1 then
						for i = 2, #content_lines do
							vim.api.nvim_buf_set_lines(
								0,
								state.line + i - 2,
								state.line + i - 2,
								false,
								{ content_lines[i] }
							)
						end
						state.line = state.line + #content_lines - 1
						state.current_content = content_lines[#content_lines]
					else
						state.current_content = content_lines[1]
					end
					vim.api.nvim_win_set_cursor(0, { state.line, #state.current_content })
				end
			end
		end)
	end
end

-- =============================================================================
-- Main Setup Function
-- =============================================================================
function M.setup(llm, services, prompts)
	-- Inject the function directly into the llm object
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
				print("No selection found")
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
				print("No selection found")
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

		local prompt_text = table.concat(visual_lines, "\n")
		local comment_syntax = opts.comment_syntax or ">"
		local instructions = opts.system_prompt or prompts.note_system_prompt
		local thinking_mode = opts.thinking_mode or "off"

		local found_service = services[service]
		if not found_service then
			print("Invalid service: " .. service)
			return
		end

		local sse_state = {
			first_chunk_received = false,
			current_content = "",
			current_col = 0,
		}

		if replace then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("cThinking...", true, true, true), "v", false)
			sse_state.line = vim.api.nvim_win_get_cursor(0)[1]
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
			vim.defer_fn(function()
				vim.api.nvim_buf_set_lines(0, selection_end_row, selection_end_row, false, { "", "Thinking..." })
				sse_state.line = selection_end_row + 2
				vim.api.nvim_win_set_cursor(0, { sse_state.line, 0 })
			end, 50)
		end

		local url = found_service.url
		local api_key_name = found_service.api_key_name
		local model = found_service.model
		local api_key = api_key_name and os.getenv(api_key_name)
		local data = {}

		-- if service == "gpt_5" then
		-- 	data = {
		-- 		model = model,
		-- 		stream = true,
		-- 		response_format = { type = "text" },
		-- 		verbosity = opts.verbosity or "medium",
		-- 		reasoning_effort = opts.reasoning_effort or "medium",
		-- 		messages = {
		-- 			{ role = "developer", content = { { type = "text", text = instructions } } },
		-- 			{ role = "user", content = { { type = "text", text = prompt_text } } },
		-- 		},
		-- 	}
		-- else
		-- 	data = {
		-- 		model = model,
		-- 		stream = true,
		-- 		max_tokens = opts.max_tokens or 8000,
		-- 		temperature = opts.temperature or 0.3,
		-- 		messages = {
		-- 			{ role = "system", content = instructions },
		-- 			{ role = "user", content = prompt_text },
		-- 		},
		-- 	}

		if service == "gpt_5" or service == "openai" then
			data = {
				model = model,
				stream = true,
				response_format = { type = "text" },
				messages = {
					{ role = "developer", content = { { type = "text", text = instructions } } },
					{ role = "user", content = { { type = "text", text = prompt_text } } },
				},
			}

			-- Only append these if they are passed in via the keymap opts
			if opts.verbosity then
				data.verbosity = opts.verbosity
			end
			if opts.reasoning_effort then
				data.reasoning_effort = opts.reasoning_effort
			end
		elseif service == "codex" then
			-- Codex uses the /v1/responses format
			data = {
				model = model,
				input = {
					{ role = "developer", content = { { type = "input_text", text = instructions } } },
					{ role = "user", content = { { type = "input_text", text = prompt_text } } },
				},
				text = {
					format = { type = "text" },
				},
				reasoning = {},
				store = false,
			}

			if opts.verbosity then
				data.text.verbosity = opts.verbosity
			end
			if opts.reasoning_effort then
				data.reasoning.effort = opts.reasoning_effort
			end
		else
			-- Standard fallback for OpenRouter, Anthropic, Grok, etc.
			data = {
				model = model,
				stream = true,
				max_tokens = opts.max_tokens or 8000,
				temperature = opts.temperature or 0.3,
				messages = {
					{ role = "system", content = instructions },
					{ role = "user", content = prompt_text },
				},
			}

			if service == "nemotron_ultra" or service == "nemotron" then
				local system_content = string.format("detailed thinking %s", thinking_mode)
				local final_user_prompt = instructions .. "\n\n---\n\n" .. prompt_text
				data.messages = {
					{ role = "system", content = system_content },
					{ role = "user", content = final_user_prompt },
				}
				if thinking_mode == "on" then
					data.temperature = opts.temperature or 0.6
					data.top_p = opts.top_p or 0.95
				else
					data.temperature = 0.0
					data.top_p = nil
				end
			end

			if instructions == prompts.code_system_prompt then
				prompt_text = string.format("Using %s for comments, respond to: %s", comment_syntax, prompt_text)
				data.messages[2].content = prompt_text
			end
		end

		local args = {
			"-N",
			"-X",
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
			table.insert(args, "-H")
			table.insert(args, "Authorization: Bearer " .. api_key)
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
					if not sse_state.first_chunk_received and service ~= "gpt_5" then
						local line_content = vim.api.nvim_buf_get_lines(0, sse_state.line - 1, sse_state.line, false)[1]
						if line_content and line_content:match("^Thinking%.%.%.") then
							vim.api.nvim_buf_set_lines(
								0,
								sse_state.line - 1,
								sse_state.line,
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

	-- Append wrapper
	function llm.prompt_selection_only_append(opts)
		opts.replace = false
		llm.prompt_selection_only(opts)
	end
end

return M
