-- ===========================================================================
-- llm.nvim Plugin Keymap Configuration
-- ===========================================================================
local M = {}

-- Helper function moved here as it is used by keybinds
local function get_comment_syntax()
	local ft = vim.bo.filetype
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
	}
	return comment_markers[ft] or "#"
end

function M.setup(llm, prompts)
	-- Claude Sonnet 4.5
	vim.keymap.set("v", "<leader>na", function()
		llm.prompt_selection_only_append({
			service = "anthropic",
			system_prompt = prompts.note_system_prompt,
		})
	end, { desc = "Claude Opus 4.6 = $5.00/$25.00" })

	-- GPT-5
	vim.keymap.set("v", "<leader>nt", function()
		llm.prompt_selection_only_append({
			service = "gpt_5",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
			verbosity = "low",
			reasoning_effort = "high",
		})
	end, { desc = "GPT-5.4 = $2.50/$15.00" })

	-- GPT-5 Nano
	vim.keymap.set("v", "<leader>ngn", function()
		llm.prompt_selection_only_append({
			service = "openai",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
			verbosity = "low",
			reasoning_effort = "medium",
		})
		-- end, { desc = "GPT-5 Mini = $0.25/$2.00" })
	end, { desc = "GPT-5.4 Nano = $0.20/$1.25" })

	-- Grok
	vim.keymap.set("v", "<leader>nk", function()
		llm.prompt_selection_only_append({
			service = "grok",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Grok 4.1 Fast Reasoning = $0.20/$0.50" })

	-- OpenRouter
	vim.keymap.set("v", "<leader>no", function()
		llm.prompt_selection_only_append({
			service = "openrouter",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Trinity Large" })

	-- Kimi
	vim.keymap.set("v", "<leader>kk", function()
		llm.prompt_selection_only_append({
			service = "kimi_k2",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Kimi K2.5 $0.45/$2.25" })

	-- Mimo V2 Flash
	vim.keymap.set("v", "<leader>nmi", function()
		llm.prompt_selection_only_append({
			service = "mimo",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Mimo V2 Flash 309B A15B - $0.09/$0.29" })

	-- Minimax
	vim.keymap.set("v", "<leader>nmx", function()
		llm.prompt_selection_only_append({
			service = "minimax",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Minimax 2.7 - $0.30/$1.20" })

	-- StepFun Step 3.5 Flash
	vim.keymap.set("v", "<leader>nsf", function()
		llm.prompt_selection_only_append({
			service = "stepfun",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "StepFun Step 3.5 Flash - Free" })

	-- ===========================================================================
	--  GOOGLE
	-- ===========================================================================

	-- Gemini Pro
	vim.keymap.set("v", "<leader>ngp", function()
		llm.prompt_selection_only_append({
			service = "gemini",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Gemini 3 Pro = $2.00/$12.00" })

	-- Gemini Flash
	vim.keymap.set("v", "<leader>ngf", function()
		llm.prompt_selection_only_append({
			service = "flash",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Gemini 3.0 Flash = $0.50/$3.00" })

	-- Gemini Flash
	vim.keymap.set("v", "<leader>ngl", function()
		llm.prompt_selection_only_append({
			service = "flash_lite",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Gemini 3.1 Flash Lite = $0.25/$1.50" })

	-- Qwen
	vim.keymap.set("v", "<leader>nw", function()
		llm.prompt_selection_only_append({
			service = "qwen3",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Qwen 3.5 Flash = $0.10/$0.40" })

	-- Gemma
	vim.keymap.set("v", "<leader>ne", function()
		llm.prompt_selection_only_append({
			service = "gemma",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Gemma3n 12B" })

	-- Deepseek
	vim.keymap.set("v", "<leader>nd", function()
		llm.prompt_selection_only_append({
			service = "r1",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Deepseek V3.2" })

	-- Tiny Llama
	vim.keymap.set("v", "<leader>tlm", function()
		llm.prompt_selection_only_append({
			service = "tiny_llama",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Llama 3.2 3B = Free" })
	-- end, { desc = "Llama 3.1 8B = $0.02/$0.05" })
	-- end, { desc = "Llama 3.2 11B = $0.05/$0.05" })

	-- Tiny Qwen
	vim.keymap.set("v", "<leader>tqw", function()
		llm.prompt_selection_only_append({
			service = "tiny_qwen3",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Qwen3 4B = Free" })

	-- Ministral
	vim.keymap.set("v", "<leader>tmi", function()
		llm.prompt_selection_only_append({
			service = "ministral",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Ministral 14B = Free" })

	-- Nemostral
	vim.keymap.set("v", "<leader>tnm", function()
		llm.prompt_selection_only_append({
			service = "nemostral",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Mistral Nemo = Free" })

	-- Devstral
	vim.keymap.set("v", "<leader>tdv", function()
		llm.prompt_selection_only_append({
			service = "devstral",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Devstral Small 24B" })

	-- Codestral
	vim.keymap.set("v", "<leader>tcd", function()
		llm.prompt_selection_only_append({
			service = "codestral",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Codestral 22B" })

	-- Nemotron Nano
	vim.keymap.set("v", "<leader>nmn", function()
		llm.prompt_selection_only_append({
			service = "nemotron",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Nemotron Nano A3B 30B" })

	-- Olmo
	vim.keymap.set("v", "<leader>nmo", function()
		llm.prompt_selection_only_append({
			service = "olmo",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Olmo 3.1 32B Instruct $0.15/$0.50" })

	-- Mistral
	vim.keymap.set("v", "<leader>nms", function()
		llm.prompt_selection_only_append({
			service = "mistral",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Mistral Medium = Free" })

	-- Nemotron
	vim.keymap.set("v", "<leader>nu", function()
		llm.prompt_selection_only_append({
			service = "nemotron_ultra",
			thinking = "off",
			system_prompt = prompts.note_system_prompt,
			temperature = 0,
		})
	end, { desc = "Nemotron 3 Super" })

	-- Cerebras
	vim.keymap.set("v", "<leader>nc", function()
		llm.prompt_selection_only_append({
			service = "cerebras",
			-- system_prompt = prompts.note_system_prompt,
			system_prompt = prompts.oreilly_prompt,
			temperature = 0.75,
		})
		-- end, { desc = "GLM 4.7 (Cerebras) = $2.25/$2.75" })
		-- end, { desc = "Cerebras (Qwen3-32B) = $0.40/$0.80" })
	end, { desc = "Cerebras (OSS-120B) = $0.35/$0.75" })

	-- Groq Qwen
	vim.keymap.set("v", "<leader>nq", function()
		llm.prompt_selection_only_append({
			service = "groq",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
		-- end, { desc = "Groq (Qwen3-32B) = $0.29/$0.59" })
	end, { desc = "Groq (OSS-120B) = $0.15/$0.60" })

	-- Z AI
	vim.keymap.set("v", "<leader>nz", function()
		llm.prompt_selection_only_append({
			service = "z_ai",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.75,
		})
	end, { desc = "Z AI (GLM 5 $1.00/$3.20)" })

	-- Replace with Mistral
	vim.keymap.set("v", "<leader>nr", function()
		llm.prompt_selection_only({
			replace = true,
			service = "mistral",
			system_prompt = prompts.note_system_prompt,
			temperature = 0.5,
		})
	end, { desc = "Replace selection with Mistral Medium" })

	-- Code Append
	vim.keymap.set("v", "<leader>ct", function()
		llm.prompt_selection_only_append({
			service = "codestral",
			system_prompt = prompts.code_system_prompt,
			temperature = 0.1,
			comment_syntax = get_comment_syntax(),
		})
	end, { desc = "Codestral = Free" })

	-- Code Replace
	vim.keymap.set("v", "<leader>cr", function()
		llm.prompt_selection_only({
			replace = true,
			service = "codestral",
			system_prompt = prompts.code_system_prompt,
			temperature = 0.1,
			comment_syntax = get_comment_syntax(),
		})
	end, { desc = "Replace with Codestral" })

	-- Title/Spiel
	vim.keymap.set("v", "<leader>mt", function()
		llm.prompt_selection_only_append({
			-- service = "flash_lite",
			service = "mistral",
			system_prompt = prompts.title_spiel_prompt,
			temperature = 0.6,
		})
	end, { desc = "Provide a title, subtitle, and spiel" })

	-- YouTube Clean
	vim.keymap.set("v", "<leader>myc", function()
		llm.prompt_selection_only_append({
			service = "grok",
			system_prompt = prompts.youtube_transcript_cleaner_prompt,
			temperature = 0.6,
		})
	end, { desc = "Generate a clean version of youtube video transcript" })

	-- YouTube Summary
	vim.keymap.set("v", "<leader>mys", function()
		llm.prompt_selection_only_append({
			service = "r1",
			system_prompt = prompts.youtube_clean_transcript_summary_generator_prompt,
			temperature = 0.6,
		})
	end, { desc = "Make a summary from Clean YouTube transcript" })

	-- Clean Scraped (Flash)
	vim.keymap.set("v", "<leader>msf", function()
		llm.prompt_selection_only({
			replace = true,
			service = "flash_lite",
			system_prompt = prompts.clean_scraped_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean Scraped Markdown Content w/ Gemini Flash Lite" })

	-- Clean Scraped (Grok)
	vim.keymap.set("v", "<leader>msg", function()
		llm.prompt_selection_only({
			replace = true,
			service = "grok",
			system_prompt = prompts.clean_scraped_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean Scraped Markdown Content w/ Grok 4" })

	-- Clean Scraped (OpenAI)
	vim.keymap.set("v", "<leader>mso", function()
		llm.prompt_selection_only({
			replace = true,
			service = "openai",
			system_prompt = prompts.clean_scraped_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean Scraped Markdown Content w/ GPT 5 Mini" })

	-- Clean Output (Grok)
	vim.keymap.set("v", "<leader>mck", function()
		llm.prompt_selection_only({
			replace = true,
			service = "grok",
			system_prompt = prompts.clean_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean LLM Output Markdown for Readability w/ Grok 4" })

	-- Clean Output (OpenAI)
	vim.keymap.set("v", "<leader>mco", function()
		llm.prompt_selection_only({
			replace = true,
			service = "openai",
			system_prompt = prompts.clean_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean LLM Output Markdown for Readability w/ GPT 5 Mini" })

	-- Clean Output (Grok - duplicate keybind in original, kept intentionally)
	vim.keymap.set("v", "<leader>mcg", function()
		llm.prompt_selection_only({
			replace = true,
			service = "grok",
			system_prompt = prompts.clean_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean LLM Output Markdown for Readability w/ Grok 4" })

	-- Clean Output (Flash)
	vim.keymap.set("v", "<leader>mcf", function()
		llm.prompt_selection_only({
			replace = true,
			service = "flash_lite",
			system_prompt = prompts.clean_markdown_prompt,
			temperature = 0.6,
		})
	end, { desc = "Clean LLM Output Markdown for Readability w/ Gemini Flash Lite" })

	-- Course Generator
	vim.keymap.set("v", "<leader>mcc", function()
		llm.prompt_selection_only({
			replace = true,
			service = "flash_lite",
			system_prompt = prompts.course_generator_prompt,
			temperature = 0.6,
		})
	end, { desc = "Convert Video Transcript to Textbook Course (Readable Content)" })

	-- Bullet Points
	vim.keymap.set("v", "<leader>mgb", function()
		llm.prompt_selection_only_append({
			-- service = "ministral",
			service = "flash_lite",
			system_prompt = prompts.note_system_prompt .. [[
                Can you split the following text into a markdown bullet list
            ]],
			temperature = 0.5,
		})
	end, { desc = "Generate bullet points from Paragraph" })

	-- Subtitle
	vim.keymap.set("v", "<leader>mgs", function()
		llm.prompt_selection_only_append({
			service = "flash_lite",
			system_prompt = prompts.note_system_prompt .. [[
                Please provide a easy and quick to read
                subtitle (as if glancing through a large amount of
                paragraphs) that captures the main idea and
                is eye catching for the only following paragraph

                Only provide the subtitle and not the paragraph
                Don't regenerate the paragraph
            ]],
			temperature = 0.5,
		})
	end, { desc = "Generate a subtitle for Paragraph" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>mei", function()
		llm.prompt_selection_only_append({
			service = "mimo",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter!" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>mem", function()
		llm.prompt_selection_only_append({
			service = "minimax",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Minimax!" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>mek", function()
		llm.prompt_selection_only_append({
			service = "grok",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Grok!" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>meg", function()
		llm.prompt_selection_only_append({
			service = "gpt_5",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter GPT-5!" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>mec", function()
		llm.prompt_selection_only_append({
			service = "cerebras",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Cerebras (OSS-120B)" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>meq", function()
		llm.prompt_selection_only_append({
			service = "qwen3",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Qwen3 A3B 30B" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>meo", function()
		llm.prompt_selection_only_append({
			service = "openrouter",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter OpenRouter" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>mer", function()
		llm.prompt_selection_only_append({
			service = "mistral",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Mistral" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>met", function()
		llm.prompt_selection_only_append({
			service = "tiny_llama",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Tiny Llama" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>mef", function()
		llm.prompt_selection_only_append({
			service = "flash_lite",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Gemini Flash Lite" })

	-- Explain It To me
	vim.keymap.set("v", "<leader>med", function()
		llm.prompt_selection_only_append({
			service = "deepseek",
			system_prompt = prompts.lets_rock_peter,
			temperature = 0.50,
		})
	end, { desc = "Explain It Peter Deepseek" })
end

return M
