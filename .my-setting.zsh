# 20230620 Oh-my-zsh 導入後調整
eval "$(anyenv init -)"

# zsh-completions
#  if type brew &>/dev/null; then
#    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
#
#    autoload -Uz compinit
#    compinit
#  fi

# rm -f ~/.zcompdump; compinit
# chmod -R go-w '/usr/local/share/zsh'

# ----------
# -- peco --
# ----------

# https://qiita.com/strsk/items/9151cef7e68f0746820d
# function peco-src () {
#   local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
#   if [ -n "$selected_dir" ]; then
#     BUFFER="cd ${selected_dir}"
#     zle accept-line
#   fi
#   zle clear-screen
# }
# zle -N peco-src
# bindkey '^]' peco-src

alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

### 過去に移動したことのあるディレクトリを選択。ctrl-[ にバインド
# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^[' peco-cdr

# git branch しつつ選択したところに checkout
# function peco-gbco() {
#   # git checkout $(git branch --sort=-authordate -vv | sed -r "s/^[ \*]+//" | peco)
#   git checkout $(git branch --sort=-authordate | sed -r "s/^[ \*]+//" | peco)
#   zle reset-prompt
# }
# zle -N peco-gbco
# bindkey '^b' peco-gbco

# -----------
# -- fzf --
# -----------
function fzf-ghq() {
  # local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  local src=$(ghq list | fzf --reverse --border --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N fzf-ghq
bindkey '^]' fzf-ghq

function fzf-git-branch() {
  git rev-parse HEAD > /dev/null 2>&1 || return

  git branch --color=always --all --sort=-committerdate |
    grep -v HEAD |
    fzf --height 50% --ansi --no-multi --preview-window right:65% \
        --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
    sed "s/.* //"
}

function fzf-git-checkout() {
  git rev-parse HEAD > /dev/null 2>&1 || return

  local branch

  branch=$(fzf-git-branch)
  if [[ "$branch" = "" ]]; then
    echo "No branch selected."
    return
  fi

  # If branch name starts with 'remotes/' then it is a remote branch. By
  # using --track and a remote branch name, it is the same as:
  # git checkout -b branchName --track origin/branchName
  if [[ "$branch" = 'remotes/'* ]]; then
    git checkout --track $branch
    return
  else
    git checkout $branch
    return
  fi
}

zle -N fzf-git-checkout
bindkey '^b' fzf-git-checkout

# fzf ssh
function fzf-ssh() {
  local host=$(grep -E "^Host " ~/.ssh/config | sed -e 's/Host[ ]*//g' | fzf --height 50% --ansi --no-multi )
  if [ -n "$host" ]; then
    echo $host
    ssh $host
  fi
}
alias ss="fzf-ssh"

function fzf-mail() {
  local emails
  emails=$(himalaya list -s 5000 -w 150)
  # echo "$emails" | fzf --reverse --preview="echo {} | awk '{print \$1}' | xargs -I {} himalaya read {} | bat" --preview-window=right:50%
  local selected_email
  selected_email=$(echo "$emails" | fzf --reverse --preview="echo {} | awk '{print \$1}' | xargs -I {} himalaya read {} | bat --color=always --style=header,grid --line-range :80" --preview-window=right:40%)
  # 選択されたメールのIDを抽出
  local email_id
  email_id=$(echo "$selected_email" | awk '{print $1}')

  # 選択されたメールの内容を表示
  echo "himalaya read $email_id"
  himalaya read "$email_id" | bat
}
alias hima="fzf-mail"

# -----------
# -- alias --
# -----------

alias g="git"
alias re="rbenv exec"
alias rer="rbenv exec rails"
alias be="bundle exec"
alias r="rails"
alias bers="bundle exec rails server"
alias pg="postgres -D /usr/local/var/postgres > /usr/local/var/log/postgres.log"
alias pe="phpenv exec"
alias pa="php artisan"
alias pepa="phpenv exec php artisan"
alias pas="php artisan serve --host 0.0.0.0"
alias pepas="phpenv exec php artisan serve --host 0.0.0.0"
alias cda="composer dump-autoload"
alias bc="bin/cake"
alias gcm="git commit -F- << EOM"
alias gst="git status --short --branch"
alias gstv="git status -v"
alias gpush='git push -u origin "$(gb)"'
alias lg='lazygit'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
# 現在いるブランチにマージ済のローカルブランチを削除するコマンド
alias gbclear="git branch --merged | egrep -v '\*|develop|main'| xargs git branch -d"

alias ll="eza -al --group-directories-first"
alias ls="eza"
alias lla="ll -a"
alias gp="git push -u origin"
alias gb="git rev-parse --abbrev-ref HEAD"
alias gbc="gb | pbcopy"
alias gbp="git push -u origin $(git rev-parse --abbrev-ref HEAD)"
alias xs="expo start"
alias xsc="expo start --clear"
# alias gbp="gp $(gb)"
alias ..="cd .."

alias ssh-igk='ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no'

alias dc='docker-compose'
alias dps='docker ps'
alias nv='NVIM_APPNAME="nvim-LazyVim" nvim'
alias nva='NVIM_APPNAME="nvim-Kabin" nvim'
alias nvb='NVIM_APPNAME="nvim-Nv" nvim'
alias diff='colordiff'

alias coded='code --disable-extensions'
alias codedd='code --disable-extensions --disable-gpu'
alias gpdeploy='php deployer.phar deploy dev -vvv --branch='

alias gpw='gh pr list | fzf | awk '{print $1}' | xargs gh pr view --web'
alias -g PR='`gh pr list | fzf | head -n 1 | cut -f1`'
alias ghp='(){gh pr view $1 -w}'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias sart='sail artisan'
alias clr='clear'
alias dvc='devcontainer'
# ----------------------------------------------------------------
# Load version control information
# autoload -Uz vcs_info
# precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:git:*' formats 'on branch %b'

# ----------------------------------------------------------------

export ANDROID_SDK=/Users/ah/Library/Android/sdk
# flutter
# export PATH="$PATH:/Users/ah/development/flutter/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi
# Source the Lazyman shell initialization for aliases and nvims selector
# shellcheck source=.config/nvim-Lazyman/.lazymanrc
[ -f ~/.config/nvim-Lazyman/.lazymanrc ] && source ~/.config/nvim-Lazyman/.lazymanrc
# Source the Lazyman .nvimsbind for nvims key binding
# shellcheck source=.config/nvim-Lazyman/.nvimsbind
[ -f ~/.config/nvim-Lazyman/.nvimsbind ] && source ~/.config/nvim-Lazyman/.nvimsbind

# for slow paste
# https://ccavales3.medium.com/code-like-a-hacker-another-neovim-terminal-setup-4613abecb7c8
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
