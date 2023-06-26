# Always launch tmux if not already in tmux
if command -v tmux &> /dev/null \
    && [ -n "$PS1" ] \
    && [[ ! "$TERM" =~ screen ]] \
    && [[ ! "$TERM" =~ tmux ]] \
    && [ -z "$TMUX" ]; then
    tmux new-session -A -s main
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Aliases
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias ll="ls -lha"
alias la="ls -ah"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load system-specific aliases and shortcuts if existent.
[ -f "$HOME/.config/local_alias" ] && source "$HOME/.config/local_alias"

# Create cache directory if it doesn't exist
[ -d $HOME/.cache/zsh ] || mkdir -p $HOME/.cache/zsh

# Load API keys
[ -f $HOME/.env ] && source $HOME/.env

# History in cache directory
HISTSIZE=12000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Set editor to nvim if available
# else use vim
if command -v nvim &> /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python
export PATH=$HOME/.local/bin:$PATH

# pip zsh completion start
function _pip_completion {
    local words cword
    read -Ac words
    read -cn cword
    reply=( $( COMP_WORDS="$words[*]" \
                COMP_CWORD=$(( cword-1 )) \
        PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip
# pip zsh completion end

# Refresh SSH_AUTH_SOCK and DISPLAY in tmux
if [ -n "$TMUX" ]; then
    function _reload_env {
        sshauth=$(tmux show-environment | grep "^SSH_AUTH_SOCK")
        if [ $sshauth ]; then
            export $sshauth
        fi
        display=$(tmux show-environment | grep "^DISPLAY")
        if [ $display ]; then
            export $display
        fi
    }
else
    function _reload_env { }
fi

function _activate_venv() {
    if [[ -z "$VIRTUAL_ENV" ]]; then
        if [[ -d ./venv ]]; then
            source ./venv/bin/activate
        fi
    else
        parentdir="$(dirname "$VIRTUAL_ENV")"
        if [[ "$PWD"/ != "$parentdir"/* ]]; then
            deactivate
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec _reload_env
add-zsh-hook chpwd _activate_venv

# zsh-autosuggestions config
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

# load fzf
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# zsh-z config
source $HOME/.zsh/plugins/zsh-z/zsh-z.plugin.zsh

# p10k theme
source $HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

# Load zsh-syntax-highlighting; should be last.
source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
