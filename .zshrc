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
export PATH="$HOME/.local/bin:$PATH"
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

# Claude
alias cl='claude --dangerously-skip-permissions'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
~() { cd $HOME }

# Tmux
t() { tmux attach || tmux new }
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

# Disk space
alias df='df -h'
alias du='du -h'
alias disk='df -h | grep -E "^/dev|Filesystem"'
alias space='du -sh * 2>/dev/null | sort -hr | head -20'

# Sing-box traffic monitor
alias vpn-log='tail -f ~/.local/share/singbox-traffic.log'
alias vpn-traffic='tail -f ~/.local/share/singbox-traffic.log | grep -E "proxy|direct" --color=auto'

# Claude Code usage
claude-usage() {
  local CREDS="$HOME/.claude/.credentials.json"
  [[ ! -f "$CREDS" ]] && echo "❌ No credentials" && return

  local TOKEN=$(jq -r '.claudeAiOauth.accessToken' "$CREDS" 2>/dev/null)
  [[ -z "$TOKEN" || "$TOKEN" == "null" ]] && echo "❌ No token" && return

  local R=$(curl -s --max-time 10 "https://api.anthropic.com/api/oauth/usage" \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)

  [[ -z "$R" ]] && echo "❌ Network error" && return

  local H5=$(echo "$R" | jq -r '.five_hour.utilization // 0')
  local H5_R=$(echo "$R" | jq -r '.five_hour.resets_at // empty')
  local D7=$(echo "$R" | jq -r '.seven_day.utilization // 0')
  local D7_R=$(echo "$R" | jq -r '.seven_day.resets_at // empty')

  time_left() {
    local t="$1"
    [[ -z "$t" ]] && echo "?" && return
    local diff=$(( $(date -d "$t" +%s) - $(date +%s) ))
    [[ $diff -lt 0 ]] && echo "0m" && return
    local d=$((diff/86400)) h=$(((diff%86400)/3600)) m=$(((diff%3600)/60))
    if [[ $d -gt 0 ]]; then
      echo "${d}d ${h}h"
    elif [[ $h -gt 0 ]]; then
      echo "${h}h ${m}m"
    else
      echo "${m}m"
    fi
  }

  local bar5="" bar7=""
  local filled5=$((${H5%.*}/5)) filled7=$((${D7%.*}/5))
  for i in {1..20}; do
    [[ $i -le $filled5 ]] && bar5+="█" || bar5+="░"
    [[ $i -le $filled7 ]] && bar7+="█" || bar7+="░"
  done

  echo ""
  echo "  \033[1;35m󰧑  Claude Code Usage\033[0m"
  echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  printf "  \033[1;36m⚡ 5-hour limit\033[0m\n"
  printf "     \033[33m%s\033[0m \033[1m%.0f%%\033[0m\n" "$bar5" "$H5"
  printf "     ↻ resets in \033[32m%s\033[0m\n" "$(time_left "$H5_R")"
  echo ""
  printf "  \033[1;34m📅 7-day limit\033[0m\n"
  printf "     \033[33m%s\033[0m \033[1m%.0f%%\033[0m\n" "$bar7" "$D7"
  printf "     ↻ resets in \033[32m%s\033[0m\n" "$(time_left "$D7_R")"
  echo ""
}
alias cu='claude-usage'

# History with fzf insertion
hhf() { 
  local cmd=$(fc -ln 1 | fzf --tac --no-sort)
  [[ -n "$cmd" ]] && print -z "$cmd"
}

# Key bindings
bindkey -s '^e' 'nvim .\n'
bindkey -s '^g' 'lazygit\n'
bindkey -s '^t' 't\n'
bindkey -s '^h' 'tmux-help\n'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/home/vasya/.bun/_bun" ] && source "/home/vasya/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rbenv
eval "$(rbenv init - zsh)"
# Lazy conda - загружается только при первом вызове
conda() {
  unfunction conda
  source /opt/miniconda3/etc/profile.d/conda.sh
  conda "$@"
}

