if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions fzf z docker history)
source $ZSH/oh-my-zsh.sh
# Basic exports
export PATH="/sbin:$HOME/.local/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'

# Tool replacements
alias cat='bat'
alias ls='eza --icons --group-directories-first'
alias l='eza --icons --group-directories-first'

# Basic functions
c() { clear }
f() { fd . | fzf }
fa() { fd . --no-ignore --hidden | fzf }
v() { nvim $(fd . | fzf) }
va() { nvim $(fd . --no-ignore --hidden | fzf) }
yy() { yazi }
cdf() { cd $(fd --type d | fzf) }
cdfa() { cd $(fd --type d --no-ignore --hidden | fzf) }
cdh() { cd $HOME }
hh() { fc -ln 1 | fzf --tac | sh }

# FZF integration
pf() { ps -ef | fzf }
rgp() { rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' }
gfzf() { git log --oneline | fzf }
gbf() { git checkout $(git branch | fzf | sed 's/^[ *]*//') }
ef() { env | fzf }
myip() { curl ipinfo.io }

# Git aliases
alias gs='git status'
gadd() { git add "$@" }
gcommit() { git commit -m "$@" }
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# NPM
ni() { npm install "$@" }
nid() { npm install --save-dev "$@" }
nr() { npm run "$@" }
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'

# Poetry
alias pl='poetry lock'
alias pi='poetry install'
pr() { poetry run "$@" }
alias pm='poetry run python main.py'

# Clipboard
alias clip='wl-paste'
copy() { echo "$@" | wl-copy }

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
~() { cd $HOME }

# Cleanup
clean-node() { rm -rf node_modules }
clean-logs() { rm -f *.log }
clean-temp() { rm -rf /tmp/* }

# History with fzf insertion
hhf() { 
  local cmd=$(fc -ln 1 | fzf --tac --no-sort)
  [[ -n "$cmd" ]] && print -z "$cmd"
}

# Key bindings
bindkey -s '^e' 'nvim .\n'
bindkey -s '^g' 'lazygit\n'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
