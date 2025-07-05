
# ─── Fastfetch или Neofetch ───────────────────────────────
# fastfetch
# neofetch --kitty ~/Pictures/neofetch1.jpg --size 175
# fastfetch --logo ~/.config/fastfetch/logo.jpg --logo-type kitty-direct --logo-width 30 --logo-height 15

# ─── Powerlevel10k Instant Prompt ─────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Пути и среда ─────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
export PATH="/sbin:$HOME/.local/bin:$PATH"

# ─── Тема ─────────────────────────────────────────────────
ZSH_THEME="powerlevel10k/powerlevel10k"

# ─── Плагины ──────────────────────────────────────────────
plugins=(
  git
  sudo
  zsh-256color
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# ─── Подключение Oh My Zsh ────────────────────────────────
source $ZSH/oh-my-zsh.sh

# ─── Powerlevel10k ────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ─── Курсор: блок и мигание ───────────────────────────────
# Делает курсор квадратным (в kitty и других терминалах)
echo -ne "\e[2 q"

# ─── Настройки пользователя ───────────────────────────────
alias ls='exa --icons --group-directories-first'
alias yy='yazi'

# ─── История ──────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ─── Автодополнение ───────────────────────────────────────
autoload -U compinit && compinit

# ─── Дополнительно (раскомментируй при необходимости) ─────
# export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL=nvim

# ─── Горячие клавиши ───────────────────────────────────────

# Ctrl+e — запуск nvim в текущей директории
bindkey -s '^e' 'nvim .\n'

# Ctrl+g — запуск lazygit
bindkey -s '^g' 'lazygit\n'

alias sudonvim='sudo -E nvim'
# Test change
