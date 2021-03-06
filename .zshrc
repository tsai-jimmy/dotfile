DEFAULT_USER=" Jimmy"

export PATH="$HOME/.tmuxifier/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export LANG=en_US.UTF-8
# RabbitMQ Config
export PATH=$PATH:/usr/local/sbin

ZSH_THEME="agnoster"

plugins=(git)

source $ZSH/oh-my-zsh.sh

#disable START/STOP output control (<C-S>, <C-Q>)
stty -ixon

# 重啟 puma
#
# - rpu       → 啟動或重啟（如果已有 pid）
# - rpu kill  → 殺掉 process，不重啟
rpu() {
  emulate -L zsh
  if [[ -d tmp ]]; then
    local action=$1
    local pid
    local animal

    if [[ -f config/puma.rb ]]; then
      animal='puma'
    else
      echo "No puma directory, aborted."
      return 1
    fi

    if [[ -r tmp/pids/server.pid && -n $(ps h -p `cat tmp/pids/server.pid` | tr -d ' ') ]]; then
      pid=`cat tmp/pids/server.pid`
    fi

    if [[ -n $action ]]; then
      case "$action" in
        pry)
          if [[ -n $pid ]]; then
            kill -9 $pid && echo "Process killed ($pid)."
          fi
          rserver_restart $animal
          ;;
        kill)
          if [[ -n $pid ]]; then
            kill -9 $pid && echo "Process killed ($pid)."
          else
            echo "No process found."
          fi
          ;;
        *)
          if [[ -n $pid ]]; then
            # TODO: control unicorn
            pumactl -p $pid $action
          else
            echo 'ERROR: "No running PID (tmp/pids/server.pid).'
          fi
      esac
    else
      if [[ -n $pid ]]; then
        # Alternatives:
        # pumactl -p $pid restart
        # kill -USR2 $pid && echo "Process killed ($pid)."

        # kill -9 (SIGKILL) for force kill
        kill -9 $pid && echo "Process killed ($pid)."
        rserver_restart $animal $([[ "$animal" == 'puma' ]])
      else
        rserver_restart $animal $([[ "$animal" == 'puma' ]])
      fi
    fi
  else
    echo 'ERROR: "tmp" directory not found.'
  fi
}

# 這是 rpu 會用到的 helper function
rserver_restart() {
  case "$1" in
    puma)
      shift
      bundle exec puma -C config/puma.rb config.ru --pidfile "tmp/pids/server.pid"
      ;;
    *)
      echo 'invalid argument'
  esac
}

# Something new for me was using command utility to call the OS's default touch command when we are overriding it.
touch () {
  mkdir -p "$(dirname "$1")"
  command touch "$1"
}

export GITHUB_UPSTREAM='otcbtc'

#function pr_for_sha {
  #git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${PWD##*/}/pull/%
#}

 pr_otc_sha() {
  current_branch = git branch | grep \* | cut -d ' ' -f2
  git log --merges --ancestry-path --oneline $1..$current_branch | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${PWD##*/}/pull/%
}

export GITHUB_UPSTREAM_1='caibaoshuo'

 pr_cai_sha() {
  current_branch = git branch | grep \* | cut -d ' ' -f2
  git log --merges --ancestry-path --oneline $1..$current_branch | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM_1/${PWD##*/}/pull/%
}
# [rails]
alias jim='pwd'
alias rs='rails s'
alias rc='rails c'
alias bi='bundle install'
alias besr='bundle exec spring rspec'
alias ram='rake annotate_models'
alias rlog='tail -f log/development.log'
alias bsl='brew services list'
alias bsr='brew services restart '
alias bss='brew services start --all' #開啟所有 brew 相關 services
alias lsps='ps -elf | grep'
# history | awk '{a[$2]++}END{for(i in a){print a[i]" "i}}' | sort -rn | head

# [git]
alias gre='git remote -v'
alias gs='git status'

alias gotowork='tmuxifier load-window example'
alias rbb='rubocop -a'


# [eslint-alias] standard
stn() {
  standard | grep "$1" | snazzy
}


# [tmux]
alias ttl='tmux ls'
alias tt='tmux attach -t '
alias ttk='tmux kill-session -t'
alias ttka='tmux list-sessions | grep -v attached | cut -d: -f1 |  xargs -t -n1 tmux kill-session -t'

# 常用 alias
alias ll='ls -al'
alias z='vim ~/.zshrc'
alias zx='cat ~/.zshrc'
alias nrd='npm run dev'
alias blog='cd ~/Dropbox/jimmy_de_blog/hexo-blog'
alias fjo='cd ~/Project2018/forjob/otcbtc'
alias fjc='cd ~/Project2018/forjob/caibaoshuo'
alias fje='cd ~/Project2018/forjob/exchange-client'
alias ffd='cd ~/Project2018/forfun/dd3'
alias ff='cd ~/Project2018/forfun/'
alias fj='cd ~/Project2020/forjob/'
alias rmf='rm -rf'
alias docker on='docker-compose up -d'
alias docker off='docker-compose stop'
alias fv='defaults write com.apple.finder AppleShowAllFiles TRUE;\killall Finder'
alias fh='defaults write com.apple.finder AppleShowAllFiles FALSE;\killall Finder'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
source /usr/local/opt/nvm/nvm.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
