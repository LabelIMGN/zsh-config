# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Custom function to ignore commands with leading spaces
function up-history-ignore-space() {
    # Loop through history backward
    local CURSOR=$CURSOR  # Save current cursor position
    zle up-line-or-history # Move up in history
    while [[ "$LBUFFER" == ' '* ]]; do
        zle up-line-or-history # Keep moving up if the line starts with a space
    done
    CURSOR=$CURSOR  # Restore cursor position
}

# Custom function for down arrow to ignore leading spaces
function down-history-ignore-space() {
    # Loop through history forward
    local CURSOR=$CURSOR  # Save current cursor position
    zle down-line-or-history # Move down in history
    while [[ "$LBUFFER" == ' '* ]]; do
        zle down-line-or-history # Keep moving down if the line starts with a space
    done
    CURSOR=$CURSOR  # Restore cursor position
}

# Bind these functions to the arrow keys
zle -N up-history-ignore-space
zle -N down-history-ignore-space
bindkey '^[[A' up-history-ignore-space  # Up arrow
bindkey '^[[B' down-history-ignore-space # Down arrow


# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

#Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -U compinit && compinit

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase # Erases duplicates
HISTIGNORE="*clear*"
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

# Aliases
alias ls='ls --color'
alias python='python3'

# Shell integration
eval "$(fzf --zsh)"

# Keybindings
bindkey '^n' autosuggest-accept
bindkey '^f' history-search-backward
bindkey '^p' history-search-forward

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
