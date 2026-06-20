DEFAULT_USER=" Jimmy"

export PATH="$HOME/.tmuxifier/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export LANG=en_US.UTF-8
# RabbitMQ Config
export PATH=$PATH:/usr/local/sbin
# export RUBYOPT='-W:no-deprecated -W:no-experimental'

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
  current_branch=$(git branch | grep \* | cut -d ' ' -f2)
  git log --merges --ancestry-path --oneline $1..$current_branch | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${PWD##*/}/pull/%
}

export GITHUB_UPSTREAM_1='caibaoshuo'

 pr_cai_sha() {
  current_branch=$(git branch | grep \* | cut -d ' ' -f2)
  git log --merges --ancestry-path --oneline $1..$current_branch | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM_1/${PWD##*/}/pull/%
}

# [rails]
alias jim='pwd'
alias rs='rails s'
alias rc='rails c'
alias bi='bundle install'
alias ber='bundle exec rspec'
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
alias gcm='git checkout master'
alias gcs='git checkout staging'

alias gotowork='tmuxifier load-window example'
alias rbb='rubocop -a'
git-list-mrs() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  git log --merges --first-parent --format="%s%n%b%n===" | awk -v branch="$current_branch" '
  BEGIN {RS="==="; FS="\n"}
  {
    merge_branch = ""
    title = ""
    mr = ""
    for(i=1; i<=NF; i++) {
      if($i ~ "into ." branch ".") {
        match($i, /PRO-[0-9]+/)
        merge_branch = substr($i, RSTART, RLENGTH)
      }
      if($i ~ /^PRO-|^\[PRO-/) {
        title = $i
      }
      if($i ~ /See merge request.*![0-9]+/) {
        match($i, /![0-9]+/)
        mr = substr($i, RSTART, RLENGTH)
      }
    }
    if(merge_branch) {
      if(title && mr) {
        # 去掉標題開頭的 [PRO-XXXXX] 或 PRO-XXXXX
        gsub(/^\[PRO-[0-9]+\]/, "", title)
        gsub(/^PRO-[0-9]+ /, "", title)
        print merge_branch " " title " (" mr ")"
      } else {
        print merge_branch " (無標題資訊)"
      }
    }
  }' | nl | head -700
}


# [eslint-alias] standard
stn() {
  standard | grep "$1" | snazzy
}


# [tmux]
alias ttl='tmux ls'
alias ttn='tmux new -s'
alias tt='tmux attach-session -d -t'
alias ttk='tmux kill-session -t'
alias ttka='tmux list-sessions | grep -v attached | cut -d: -f1 |  xargs -t -n1 tmux kill-session -t'

# 常用 alias
alias findip='ifconfig | grep 192.168.3'
alias ll='ls -al'
alias z='vim ~/.zshrc'
alias q='vim ~/.gitconfig'
alias s='vim ~/.ssh/config'
alias zx='cat ~/.zshrc'
alias nrd='npm run dev'
alias ng3000='ngrok http 3000'
alias jami='zip -er /Users/jimmy/Desktop/jami.zip'  # 加密
alias blog='cd ~/Dropbox/jimmy_de_blog/hexo-blog'
alias fjo='cd ~/Project2018/forjob/otcbtc'
alias pro='cd ~/Project2020/forjob/raichu'
alias fje='cd ~/Project2018/forjob/exchange-client'
alias ffd='cd ~/Project2018/forfun/dd3'
alias ex='cd ~/Project2020/forjob/bitex/'
alias ff='cd ~/Project2020/forfun/'
alias fj='cd ~/Project2020/forjob/'
alias rmf='rm -rf'
alias dockeron='docker-compose up -d'
alias dockeroff='docker-compose stop'
alias fv='defaults write com.apple.finder AppleShowAllFiles TRUE;\killall Finder'
alias fh='defaults write com.apple.finder AppleShowAllFiles FALSE;\killall Finder'
alias arm='env /usr/bin/arch -arm64 /bin/bash --login'
alias intel='env /usr/bin/arch -x86_64 /bin/zsh --login'
alias codex-openai='codex --config model_provider=openai --config model=gpt-5'
alias codex-oss='codex --config model_provider=oss --config codellama'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
source /usr/local/opt/nvm/nvm.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH=/Users/Shared/DBngin/mysql/5.7.23/bin:$PATH
export PATH="/usr/local/opt/postgresql@13/bin:$PATH"
export PATH=~/.local/bin:$PATH
export PATH="/usr/local/opt/openssl@3/bin:$PATH"
export LDFLAGS="-L$(brew --prefix openssl@3)/lib"
export CPPFLAGS="-I$(brew --prefix openssl@3)/include"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Agnoster theme configuration - maintain legacy colors
export AGNOSTER_CONTEXT_BG=blue
export AGNOSTER_CONTEXT_FG=7  # white

export AGNOSTER_DIR_BG=7      # white
export AGNOSTER_DIR_FG=black

export AGNOSTER_GIT_CLEAN_BG=green
export AGNOSTER_GIT_CLEAN_FG=black
export AGNOSTER_GIT_DIRTY_BG=yellow
export AGNOSTER_GIT_DIRTY_FG=black

export AGNOSTER_BZR_CLEAN_BG=green
export AGNOSTER_BZR_CLEAN_FG=black
export AGNOSTER_BZR_DIRTY_BG=yellow
export AGNOSTER_BZR_DIRTY_FG=black

export AGNOSTER_HG_NEWFILE_BG=red
export AGNOSTER_HG_NEWFILE_FG=white
export AGNOSTER_HG_CHANGED_BG=yellow
export AGNOSTER_HG_CHANGED_FG=black
export AGNOSTER_HG_CLEAN_BG=green
export AGNOSTER_HG_CLEAN_FG=black

export AGNOSTER_VENV_BG=blue
export AGNOSTER_VENV_FG=black

export AGNOSTER_CONDA_BG=magenta
export AGNOSTER_CONDA_FG=black

export AGNOSTER_STATUS_BG=black
export AGNOSTER_STATUS_FG=default
export AGNOSTER_STATUS_RETVAL_FG=red
export AGNOSTER_STATUS_ROOT_FG=yellow
export AGNOSTER_STATUS_JOB_FG=cyan
export AGNOSTER_STATUS_RETVAL_NUMERIC=false

export AGNOSTER_RUBY_BG=red
export AGNOSTER_RUBY_FG=default
export RUBY_TCP_NO_FAST_FALLBACK=1

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/Library/Python/3.11/bin:$PATH"
export LENS_KUBECONFIG="$HOME/.kube/rails/lens-staging-cluster.yaml"

# Force ARM64 architecture for M-series Mac
if [ "$(uname -m)" = "arm64" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
