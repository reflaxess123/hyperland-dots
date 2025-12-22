if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git fzf z docker history)
source $ZSH/oh-my-zsh.sh
# Arch plugins (НЕ oh-my-zsh)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
gcom() { git commit -m "$@" }
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

# Tmux
ta() { tmux attach -t "$@" }
tmux-help() {
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║              OH MY TMUX - HOTKEYS                        ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  Prefix: Ctrl+A                                          ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  СЕССИИ:                                                 ║"
  echo "║    prefix + C-c   - новая сессия                         ║"
  echo "║    prefix + C-f   - найти сессию                         ║"
  echo "║    prefix + d     - отключиться от сессии                ║"
  echo "║    prefix + $     - переименовать сессию                 ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  ОКНА:                                                   ║"
  echo "║    prefix + c     - новое окно                           ║"
  echo "║    prefix + C-h   - предыдущее окно                      ║"
  echo "║    prefix + C-l   - следующее окно                       ║"
  echo "║    prefix + Tab   - последнее активное окно              ║"
  echo "║    prefix + 1-9   - перейти к окну N                     ║"
  echo "║    prefix + ,     - переименовать окно                   ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  ПАНЕЛИ:                                                 ║"
  echo "║    prefix + -     - разделить горизонтально              ║"
  echo "║    prefix + _     - разделить вертикально                ║"
  echo "║    prefix + h/j/k/l - перемещение между панелями         ║"
  echo "║    prefix + H/J/K/L - изменить размер панели             ║"
  echo "║    prefix + < / > - поменять панели местами              ║"
  echo "║    prefix + x     - закрыть панель                       ║"
  echo "║    prefix + z     - развернуть/свернуть панель           ║"
  echo "║    prefix + +     - развернуть панель в новое окно       ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  КОПИРОВАНИЕ:                                            ║"
  echo "║    prefix + Enter - режим копирования                    ║"
  echo "║    prefix + b     - список буферов                       ║"
  echo "║    prefix + p     - вставить из буфера                   ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  ДРУГОЕ:                                                 ║"
  echo "║    prefix + e     - открыть конфиг                       ║"
  echo "║    prefix + r     - перезагрузить конфиг                 ║"
  echo "║    prefix + m     - вкл/выкл мышь                        ║"
  echo "╚══════════════════════════════════════════════════════════╝"
}
alias th='tmux-help'

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
bindkey -s '^t' 'tmux\n'
bindkey -s '^h' 'tmux-help\n'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/home/vasya/.bun/_bun" ] && source "/home/vasya/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export UV_PROJECT_ENVIRONMENT=.venv-linux
