# Environment Variables
export XDG_SESSION_TYPE=x11
export CLICOLOR=true
export BAT_THEME="Catppuccin Mocha"

# eval $(dircolors ~/.bliss_dircolors)
# eval $(dircolors ~/.dracula_dircolors)
# alias ls='ls --color=tty'
# alias ls='ls --color=auto'
alias l='eza -1s oldest'
alias ls='eza -1s newest'


# is it possible to make this command sort by time and date at the bottom?
#alias ls='eza -s modified --reverse'
alias ll='eza -lhs newest'

alias dictionary='~/Scripts/dictionary.py'

path+=('/home/dusts/.bin/')
path+=('/home/dusts/.local/bin/')
alias chatgpt4o-mini='chatgpt.sh -i "respond in a simple and concise manner" --model gpt-4o-mini --max-tokens 500'
alias chatgpt4o='chatgpt.sh -i "respond in a simple and concise manner" --model chatgpt-4o-latest --max-tokens 250'
# BlueBirdBack/groq
alias groq='python ~/.bin/groq/scripts/run_groq.py short'

#alias fzfvim='nvim $(fzf --preview '\''bat --style=numbers --color=always {}'\'' --query="$1" --exit-0)'
#alias fzfvim='nvim "$(FZF_DEFAULT_COMMAND="fd --type f -e md -e lua -e txt -e sh -e py -e cpp -e json -e conf -e zshrc" FZF_DEFAULT_OPTS="--preview '\''bat --style=numbers --color=always {}'\''" fzf --query="$1" --exit-0)"'

# Debian Distro Specific Version

fzfvim() {
    local query="${1:-}"
    
    FZF_DEFAULT_COMMAND="fd -H --type f -e md -e lua -e txt -e sh -e py -e cpp -e json -e conf -e zshrc" \
    FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always {}' --bind 'change:reload:fd -H --type f -e md -e lua -e txt -e sh -e py -e cpp -e json -e conf -e zshrc {q} || true'" \
    fzf --ansi --phony --query="$query" --exit-0 | while IFS= read -r file; do
        nvim "$file"
    done
}
livegrep() {
    local search_dir="${1:-.}"
    
    fzf --phony --query '' \
        --bind "change:reload:sh -c '
          query=\"\$1\"
          # Split query into words
          set -- \$query
          # Start with first word: search recursively using absolute paths
          cmd=\"rg -il0 \\\"\$1\\\" \"\$(pwd)\"\"
          shift
          # For each additional word, chain the search using xargs
          for word in \"\$@\"; do
             cmd=\"\$cmd | xargs -0 rg -il0 \\\"\$word\\\"\"
          done
          # Convert null-separated output to newline-separated list
          eval \"\$cmd\" | tr \"\\0\" \"\\n\"
        ' _ {q} || true" \
        --delimiter ':' \
        --preview 'file={1}; last_word=$(echo {q} | awk "{print \$NF}"); line=$(rg --line-number --no-heading --smart-case "$last_word" "$file" | head -n1 | cut -d: -f1); bat --style=numbers --color=always --highlight-line "$line" "$file"' \
        --preview-window 'right:50%:wrap' \
        --bind 'enter:execute:line=$(rg --line-number --no-heading --smart-case "$(echo {q} | awk "{print \$NF}")" {1} | head -n1 | cut -d: -f1); nvim "+normal! ${line}G" {1}'
}

# livegrep() {
#     local search_dir="${1:-.}"
#
#     # Start fzf with an initial query or empty and configure it to call rg upon query change
#     FZF_DEFAULT_COMMAND="rg --column --line-number --no-heading --color=always --smart-case '' $search_dir" \
#     fzf --ansi \
#         --bind "change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} $search_dir" \
#         --delimiter ':' \
#         --preview 'batcat --style=numbers --color=always --highlight-line {2} --line-range {2}: {1}' \
#         --preview-window 'right:50%:wrap' \
#         --phony \
#         --query='' \
#         | while IFS=: read -r file line _; do
#             nvim "+normal! ${line}G" "$file"
#         done
# }

# Most Used API Keys

# =================================================================================================
# ZenSH
# =================================================================================================

# Plugin Settings

# fzf-tab
autoload -Uz compinit && compinit

# ZSH Plugins
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.config/zsh/plugins/zsh-groq-llm/zsh-llm-suggestions.zsh

# Plugin Keybindings
bindkey '^o' zsh_llm_suggestions_groq # Ctrl + O to have Groq suggest a command
bindkey '^[^o' zsh_llm_suggestions_groq_explain # Ctrl + alt + O to have Groq explain a command

# Plugin Settings
# zsh-completions - Load completions
fpath=(~/.config/zsh/plugins/zsh-completions/src $fpath)

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=10000
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

# Shell integrations
# eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
# =================================================================================================
# ZenSH
# =================================================================================================

#  Settings
#if [[ "$TERM" == "xterm-kitty" || "$TERM" == "xterm-256color" || "$TERM_PROGRAM" == "WarpTerminal" ]]; then
if [[ "$TERM" == "xterm-kitty" || "$TERM" == "tmux-256color" || "$TERM_PROGRAM" == "WarpTerminal" ]]; then
    export TERM=xterm-256color
    eval "$(starship init zsh)"
fi

#eval "$(zoxide init zsh)"

# Special Functions
# =============================================================================

fzpdf() {
    local file filename
    file=$(fd -epdf | fzf --preview 'pdftotext {} - 2>/dev/null | head -50')
    if [[ -n "$file" ]]; then
        zathura --fork --mode fullscreen "$file"
        sleep 0.2
        i3-msg '[class="Zathura"] focus' > /dev/null
        
        # Get just the filename and truncate if too long
        filename=$(basename "$file")
        if [[ ${#filename} -gt 40 ]]; then
            filename="${filename:0:37}..."
        fi
        
        # Send notification using dunst
        DISPLAY=:0 dunstify -u low -t 2000 'PDF Viewer' "Opened: $filename"
    fi
} 2>/dev/null

# UV Scraping Environment Function - Fixed Version
scr() {
    # Check if argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: scr <script_path> [arguments...]"
        return 1
    fi
    
    # Set the environment path
    local env_path="$HOME/Environments/Scraping"
    
    # Check if environment exists
    if [ ! -d "$env_path/.venv" ]; then
        echo "Error: UV environment not found at $env_path"
        echo "Please create it first with:"
        echo "  mkdir -p $env_path && cd $env_path && uv init && uv venv && uv add markdownify"
        return 1
    fi
    
    # Get the script path and remaining arguments
    local script_path="$1"
    shift  # Remove first argument, keeping any additional args
    
    # Expand tilde in script path if present
    script_path="${script_path/#\~/$HOME}"
    
    # Check if script exists
    if [ ! -f "$script_path" ]; then
        echo "Error: Script not found: $script_path"
        return 1
    fi
    
    # Run the script with uv environment WITHOUT changing directory
    uv run --project "$env_path" python "$script_path" "$@"
}
