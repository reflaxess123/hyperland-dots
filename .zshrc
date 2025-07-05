if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH="/sbin:$HOME/.local/bin:$PATH"
export EDITOR='nvim'
export VISUAL=nvim

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  sudo
  zsh-256color
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

echo -ne "\e[2 q"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

autoload -U compinit && compinit

alias ls='exa --icons --group-directories-first'
alias ll='exa -la --icons --group-directories-first --git'
alias la='exa -la --icons --group-directories-first --git --all'
alias lt='exa --tree --icons --group-directories-first'
alias l='exa -l --icons --group-directories-first --git'
alias yy='yazi'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias du='dust'
alias df='duf'
alias top='btop'
alias ps='procs'
alias sudonvim='sudo -E nvim'

bindkey -s '^e' 'nvim .\n'
bindkey -s '^g' 'lazygit\n'

if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --margin=1 --padding=1'
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'exa --tree --color=always {} | head -200'"
  
  cdf() {
    local dir
    dir=$(find ${1:-.} -type d 2>/dev/null | fzf --preview 'exa --tree --color=always {} | head -200') && cd "$dir"
  }
  
  fzf_git_log() {
    git log --oneline --color=always | fzf --ansi --preview 'git show --color=always {1}' | cut -d' ' -f1 | xargs -I {} git show {}
  }
  
  alias cdf='cdf'
  alias fgl='fzf_git_log'
fi
