-- ===========================================================================
-- llm.nvim Plugin LLM Service Configuration
-- ===========================================================================
return {
	gpt_5 = {
		url = "https://api.openai.com/v1/chat/completions",
		model = "gpt-5.4",
		api_key_name = "OPENAI_API_KEY",
	},
	anthropic = {
		url = "https://api.anthropic.com/v1/chat/completions",
		model = "claude-opus-4-6",
		api_key_name = "ANTHROPIC_API_KEY",
	},
	grok = {
		url = "https://api.x.ai/v1/chat/completions",
		model = "grok-4-1-fast-non-reasoning",
		api_key_name = "GROK_API_KEY",
	},
	openrouter = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "arcee-ai/trinity-large-preview:free",
		api_key_name = "OPENROUTER_API_KEY",
	},
	flash_lite = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "google/gemini-3.1-flash-lite-preview",
		api_key_name = "OPENROUTER_API_KEY",
	},
	flash = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "google/gemini-3-flash-preview",
		api_key_name = "OPENROUTER_API_KEY",
	},
	gemini = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "google/gemini-3.1-pro-preview",
		api_key_name = "OPENROUTER_API_KEY",
	},
	cerebras = {
		url = "https://api.cerebras.ai/v1/chat/completions",
		model = "gpt-oss-120b",
		api_key_name = "CEREBRAS_API_KEY",
	},
	groq = {
		url = "https://api.groq.com/openai/v1/chat/completions",
		-- ($0.29/$0.59)
		model = "qwen/qwen3-32b",
		api_key_name = "GROQ_API_KEY",
	},
	qwen3 = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "qwen/qwen3.5-flash-02-23",
		api_key_name = "OPENROUTER_API_KEY",
	},
	oss = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "openai/gpt-oss-120b",
		api_key_name = "OPENROUTER_API_KEY",
	},
	openai = {
		url = "https://api.openai.com/v1/chat/completions",
		model = "gpt-5.4-nano",
		api_key_name = "OPENAI_API_KEY",
	},
	tiny_qwen3 = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		-- ($0.05/$0.15)
		model = "qwen/qwen3.5-9b",
		api_key_name = "OPENROUTER_API_KEY",
	},
	z_ai = {
		url = "https://api.z.ai/api/paas/v4/chat/completions",
		model = "glm-5",
		api_key_name = "Z_API_KEY",
	},
	r1 = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "deepseek/deepseek-r1-0528-qwen3-8b",
		api_key_name = "OPENROUTER_API_KEY",
	},
	tiny_llama = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		-- ($0.02/$0.05)
		model = "meta-llama/llama-3.1-8b-instruct",
		api_key_name = "OPENROUTER_API_KEY",
	},
	gemma = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		-- ($0.13/$0.40)
		-- model = "google/gemma-4-26b-a4b-it",
		-- ($0.14/$0.40)
		model = "google/gemma-4-31b-it",
		api_key_name = "OPENROUTER_API_KEY",
	},
	mistral = {
		url = "https://api.mistral.ai/v1/chat/completions",
		model = "mistral-small-latest",
		api_key_name = "MISTRAL_API_KEY",
	},
	olmo = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "allenai/olmo-3.1-32b-instruct",
		api_key_name = "OPENROUTER_API_KEY",
	},
	stepfun = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		-- cost = $0.10/$0.30
		-- model = "stepfun/step-3.5-flash",
		model = "stepfun/step-3.5-flash:free",
		api_key_name = "OPENROUTER_API_KEY",
	},
	mimo = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		-- cost = $0.09/$0.29
		model = "xiaomi/mimo-v2-flash",
		api_key_name = "OPENROUTER_API_KEY",
	},
	minimax = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "minimax/minimax-m2.7",
		api_key_name = "OPENROUTER_API_KEY",
	},
	ministral = {
		url = "https://api.mistral.ai/v1/chat/completions",
		-- ($0.10/$0.10)
		model = "ministral-3b-latest",
		-- ($0.20/$0.20)
		-- model = "ministral-8b-latest",
		-- ($0.30/$0.30)
		-- model = "ministral-14b-latest",
		api_key_name = "MISTRAL_API_KEY",
	},
	devstral = {
		url = "https://api.mistral.ai/v1/chat/completions",
		model = "devstral-small-latest",
		api_key_name = "MISTRAL_API_KEY",
	},
	codestral = {
		url = "https://codestral.mistral.ai/v1/chat/completions",
		model = "codestral-latest",
		api_key_name = "CODESTRAL_API_KEY",
	},
	nemostral = {
		url = "https://api.mistral.ai/v1/chat/completions",
		model = "open-mistral-nemo",
		api_key_name = "MISTRAL_API_KEY",
	},
	nemotron = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "nvidia/nemotron-3-super-120b-a12b:free",
		api_key_name = "OPENROUTER_API_KEY",
	},
	nemotron_ultra = {
		url = "https://openrouter.ai/api/v1/chat/completions",
		model = "nvidia/llama-3.1-nemotron-ultra-253b-v1",
		api_key_name = "OPENROUTER_API_KEY",
	},
	deepseek = {
		url = "https://api.deepseek.com/v1/chat/completions",
		model = "deepseek-chat",
		api_key_name = "DEEPSEEK_API_KEY",
	},
	ollama_code = {
		url = "http://10.0.0.103:11434/v1/chat/completions",
		model = "qwen2.5-coder:14b",
		api_key_name = "OLLAMA_API_KEY",
	},
	ollama_notes = {
		url = "http://127.0.0.1:11434/v1/chat/completions",
		model = "qwen3:0.6b",
		api_key_name = "OLLAMA_API_KEY",
	},
}
