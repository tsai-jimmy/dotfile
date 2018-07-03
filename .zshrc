DEFAULT_USER=" Jimmy"

export PATH="$HOME/.tmuxifier/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim

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



# [rails]
alias rs='rails s'
alias rc='rails c'
alias bi='bundle install'
alias rlog='tail -f log/development.log'


# [git]
alias gs='git status'
alias gre='git remote -v'
alias gotowork='tmuxifier load-window example'

# [tmux]
alias tt s='tmux ls'
alias tt='tmux attach -t'

# 常用 alias
alias ll='ls -l'
alias z='vim ~/.zshrc'
alias nrd='npm run dev'
alias ff='cd ~/Project2018/forfun/'
alias fj='cd ~/Project2018/forjob/'
alias rmf='rm -rf'
alias docker on='docker-compose up -d'
alias docker off='docker-compose stop'
alias fv='defaults write com.apple.finder AppleShowAllFiles TRUE;\killall Finder'
alias fh='defaults write com.apple.finder AppleShowAllFiles FALSE;\killall Finder'

export NVM_DIR="/Users/Nic/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
