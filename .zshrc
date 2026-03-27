export BAT_THEME="Catppuccin Mocha"
export HYPRSHOT_DIR="$HOME/Pictures/Screenshots/"

eval $(dircolors ~/.dir_colors)

# export QT_QPA_PLATFORM=xcb vlc
alias ls='eza -1rs oldest'
alias ll='eza -lhs newest'

# Add ~/.local/bin to PATH for custom scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt:$PATH"

path+=('/home/dusts/.bin/')

# API Keys
# =======


# =================================================================================================
# FZF Utilities
# =================================================================================================

# Shared extension list for fd-based fzf functions
FZF_FD_EXTS=(-e md -e lua -e txt -e sh -e py -e cpp -e json -e conf -e zshrc)
FZF_FD_EXTS_FULL=("${FZF_FD_EXTS[@]}" -e js -e ts -e html -e css -e yml -e yaml -e xml -e toml -e ini -e cfg -e log -e sql -e rs -e go -e java -e c -e h -e rb -e php -e pl -e vim -e rc)

fzfvim() {
    local query="${1:-}"
    local ext_str="${FZF_FD_EXTS[*]}"

    FZF_DEFAULT_COMMAND="fd -H --type f ${ext_str}" \
    FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always {}' --bind 'change:reload:fd -H --type f ${ext_str} {q} || true'" \
    fzf --ansi --phony --query="$query" --exit-0 | while IFS= read -r file; do
        nvim "$file"
    done
}

livegrep() {
    local search_dir="${1:-.}"
    local ext_str="${FZF_FD_EXTS_FULL[*]}"

    FZF_DEFAULT_COMMAND="fd -H --type f ${ext_str}" \
    fzf --phony --query '' \
        --bind "change:reload:sh -c '
          query=\"\$1\"
          if [ -z \"\$query\" ]; then
            fd -H --type f ${ext_str}
          else
            fd -H --type f ${ext_str} -0 | xargs -0 rg -l \"\$query\" 2>/dev/null || true
          fi
        ' _ {q} || true" \
        --delimiter ':' \
        --preview 'file={1}; last_word=$(echo {q} | awk "{print \$NF}"); if [ -n "$last_word" ]; then line=$(rg --line-number --no-heading --smart-case "$last_word" "$file" 2>/dev/null | head -n1 | cut -d: -f1); if [ -n "$line" ]; then start_line=$((line - 5)); if [ $start_line -lt 1 ]; then start_line=1; fi; end_line=$((line + 45)); bat --style=numbers --color=always --highlight-line "$line" --line-range "$start_line:$end_line" "$file" 2>/dev/null; else bat --style=numbers --color=always "$file" 2>/dev/null; fi; else bat --style=numbers --color=always "$file" 2>/dev/null; fi' \
        --preview-window 'right:50%:wrap' \
        --bind 'enter:execute:last_word=$(echo {q} | awk "{print \$NF}"); if [ -n "$last_word" ]; then line=$(rg --line-number --no-heading --smart-case "$last_word" {1} 2>/dev/null | head -n1 | cut -d: -f1); nvim "+${line:-1}" {1}; else nvim {1}; fi'
}

# =================================================================================================
# ZenSH - Plugins & Shell Configuration
# =================================================================================================

# 1. Set keymap first
bindkey -e

# 2. fpath BEFORE compinit so zsh-completions are registered
fpath=(~/.config/zsh/plugins/zsh-completions/src $fpath)
autoload -Uz compinit && compinit

# 3. Source plugins (after compinit so they can register completions)
source ~/.config/zsh/plugins/zsh-syntax-highlighting/Themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.config/zsh/plugins/zsh-groq-llm/zsh-llm-suggestions.zsh
source ~/.config/zsh/plugins/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# 4. Shell integrations (after plugins, after bindkey -e)
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# 5. Custom keybindings LAST (override anything above)
bindkey '^o' zsh_llm_suggestions_groq # Ctrl+O for Groq suggestions
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# =================================================================================================
# Prompt
# =================================================================================================

if [[ "$TTYD_WEB_SESSION" == "true" ]]; then
    # A clean prompt: username@host:~/current/path$
    PROMPT='%F{blue}%n@%m%f:%F{yellow}%~%f$ '
else
    if [[ "$TERM" == "xterm-kitty" || "$TERM" == "xterm-256color" || "$TERM_PROGRAM" == "WarpTerminal" ]]; then
        eval "$(starship init zsh)"
    fi
fi

# =================================================================================================
# Utility Functions
# =================================================================================================

# Usage: run_with scraping my_script.py
# or: run_with data_science notebook_script.py
function run_with() {
    local env_name=$1
    shift

    local env_path="$HOME/Environments/$env_name"

    if [[ -d "$env_path" ]]; then
        echo "Running with uv environment: $env_name"
        "$env_path/.venv/bin/python" "$@"
    else
        echo "Environment '$env_name' not found in ~/Environments/"
        return 1
    fi
}

alias scr='run_with Scraping'
alias dsc='run_with data_science'
