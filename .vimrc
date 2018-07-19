"----------------- Vundle ----------------
"
set nocompatible             " not compatible with the old-fashion vi mode
filetype off                 " required!

" http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
echo "Installing Vundle.."
echo ""
silent !mkdir -p ~/.vim/bundle
silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
let iCanHazVundle=0
endif

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

call vundle#end()

"
"----------------- End Vundle --------------


" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamedplus                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
colors solarized_dark                                        " vim color scheme

" Performance
set ttyfast
set lazyredraw
set regexpengine=1

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" keyboard shortcuts
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" 連續縮排
nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0


" Syntastic ------------------------------
let g:syntastic_vue_tidy_ignore_errors=[" proprietary attribute \"el-"]
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map={'passive_filetypes':['html']}
" 设置错误符号
let g:syntastic_error_symbol='✗'
" 设置警告符号
let g:syntastic_warning_symbol='⚠'
" 是否在打开文件时检查
let g:syntastic_check_on_open=0
" 是否在保存文件后检查
let g:syntastic_check_on_wq=1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Highlight current line
set cursorline

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell
" extra rails.vim help
autocmd User Rails silent! Rnavcommand decorator      app/decorators            -glob=**/* -suffix=_decorator.rb
autocmd User Rails silent! Rnavcommand observer       app/observers             -glob=**/* -suffix=_observer.rb
autocmd User Rails silent! Rnavcommand feature        features                  -glob=**/* -suffix=.feature
autocmd User Rails silent! Rnavcommand job            app/jobs                  -glob=**/* -suffix=_job.rb
autocmd User Rails silent! Rnavcommand mediator       app/mediators             -glob=**/* -suffix=_mediator.rb
autocmd User Rails silent! Rnavcommand stepdefinition features/step_definitions -glob=**/* -suffix=_steps.rb

" ------------------------------------------------------------
"  vim-vue
" ------------------------------------------------------------
autocmd BufRead,BufNewFile *.vue setlocal filetype=html syntax=javascript

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Go crazy!
if filereadable(expand("~/.vimrc.local"))
  " In your .vimrc.local, you might like:
  "
  " set autowrite
  " set nocursorline
  " set nowritebackup
  " set whichwrap+=<,>,h,l,[,] " Wrap arrow keys between lines
  "
  " autocmd! bufwritepost .vimrc source ~/.vimrc
  " noremap! jj <ESC>
  source ~/.vimrc.local
endif

map <C-n> :NERDTreeToggle<CR>

" keyboard shortcuts
inoremap jj <ESC>

if has('vim_starting')
  if executable('w')
    " let result = system("w --no-header --short | wc -l")
    " if str2nr(result) > 1
    if 1
      noremap  ,, <C-\><C-N>
      noremap! ,, <C-\><C-N>
      inoremap jj <C-\><C-N>

      nnoremap <silent> <Tab>   :bnext<CR>
      nnoremap <silent> <s-Tab> :bprevious<CR>

      nnoremap gr gT

      nunmap <C-H>

      " TODO: install your finder plugin
      " nmap <silent> <C-P> <LocalLeader>F

      autocmd User Rails call s:rails_test_helpers_for_pair()

      function! s:rails_test_helpers_for_pair() "{{{
        let type = rails#buffer().type_name()
        let relative = rails#buffer().relative()
        if type =~ '^spec'
          nmap \t [rtest]
          nnoremap <silent> [rtest]l :call <SID>rails_test_tmux('h')<CR>
          nnoremap <silent> [rtest]w :call <SID>rails_test_tmux('new-window')<CR>
          nnoremap <silent> [rtest]. :call <SID>rails_test_tmux('last')<CR>
        end
      endfunction "}}}
    endif
  endif
endif




function! s:rails_test_tmux(method) "{{{
  let [it, path] = ['', '']

  let rails_type = rails#buffer().type_name()
  let rails_relative = rails#buffer().relative()

  if rails_type =~ '^spec'
    let it = matchstr(
          \   getline(
          \     search('^\s*it\s\+\(\)', 'bcnW')
          \   ),
          \   'it\s*[''"]\zs.*\ze[''"]'
          \ )
    let path = rails_relative
  end

  if empty(path)
    let it   = get(s:, 'rails_test_tmux_last_it', '')
    let path = get(s:, 'rails_test_tmux_last_path', '')
  end

  let s:rails_test_tmux_last_it = it
  let s:rails_test_tmux_last_path = path

  if empty(it)
    let test_command = printf('bundle exec rspec %s', path)
  else
    let test_command = printf('bundle exec rspec %s -e %s', path, shellescape(escape(it, "()")))
  endif

  let type_short = matchstr(rails_type, '\vtest-\zs.{4}')
  if type_short == 'spec'
    let title = type_short
  elseif type_short == 'func'
    let title = type_short
  else
    let title = type_short
  endif


  call TmuxNewWindow({
        \   "text": test_command,
        \   "title": '∫ ' . title,
        \   "directory": rails#app().root,
        \   "remember_pane": 1,
        \   "method": a:method
        \ })
endfunction "}}}




function! TmuxNewWindow(...) "{{{
  let options = a:0 ? a:1 : {}
  let text = get(options, 'text', '')
  let title = get(options, 'title', '')
  let directory = get(options, 'directory', getcwd())
  let method = get(options, 'method', 'new-window')
  let size = get(options, 'size', '40')
  let remember_pane = get(options, 'remember_pane', 0)
  let pane = ''

  if method == 'last'
    if !exists('s:last_tmux_pane') || empty(s:last_tmux_pane)
      echohl WarningMsg | echomsg "Can't find last tmux pane. Continue with 'new-window'." | echohl None
      let method = 'new-window'
    else
      " if system(printf('tmux list-pane -s -F "#{pane_id}" | egrep %%%s$', s:last_tmux_pane) =~ '%'
      "   let pane = s:last_tmux_pane
      " else
      "   echohl WarningMsg | echomsg "Can't find last tmux pane. Continue with 'new-window'." | echohl None
      "   let method = 'new-window'
      " endif
      let pane = s:last_tmux_pane
    endif
  elseif method == 'quit'
    if !exists('s:last_tmux_pane') || empty(s:last_tmux_pane)
      echohl WarningMsg | echomsg "Can't find last used pane." | echohl None
      return
    else
      call system('tmux kill-pane -t ' . matchstr(s:last_tmux_pane, '%\d\+'))
      unlet! s:last_tmux_pane
      return
    endif
  endif

  if empty(pane) && method != 'new-window'
    " use splitted pane if available
    let pane = matchstr(
          \   system('tmux list-pane -F "#{window_id}#{pane_id}:#{pane_active}" | egrep 0$'),
          \   '\zs@\d\+%\d\+\ze'
          \ )
  endif

  if empty(pane)
    if method == 'new-window'
      let cmd = 'tmux new-window -a '
            \ . (empty(title) ? '' : printf('-n %s', shellescape(title)))
            \ . printf(' -c %s', shellescape(directory))
    elseif method == 'v'
      let cmd = 'tmux split-window -d -v '
            \ . printf('-p %s -c %s ', size, shellescape(directory))
    elseif method == 'h'
      let cmd = 'tmux split-window -d -h '
            \ . printf(' -c %s ', shellescape(directory))
    endif

    let pane = substitute(
          \   system(cmd . ' -P -F "#{window_id}#{pane_id}"'), '\n$', '', ''
          \ )
  endif

  if remember_pane
    let s:last_tmux_pane = pane
  endif

  let window_id = matchstr(pane, '@\d\+')
  let pane_id = matchstr(pane, '%\d\+')

  if !empty(text)
    let cmd = printf(
          \   'tmux set-buffer %s \; paste-buffer -t %s -d \; send-keys -t %s Enter',
          \   shellescape(text),
          \   pane_id,
          \   pane_id
          \ )
    sleep 300m
    call system('tmux select-window -t ' . window_id)
    call system(cmd)
  endif
endfunction "}}}




set secure



xmap <CR> <Plug>(EasyAlign)
xmap <LocalLeader>A <Plug>(EasyAlign)
let g:easy_align_interactive_modes = ['l', 'a']
let g:easy_align_ignore_unmatched  = 0

" }}}2   Context sensitive H,L.     {{{2

" Ref: tyru - https://github.com/tyru/dotfiles
" TODO 內部也統一使用 s:scroll_up / down
nnoremap <silent> H :<C-u>call HContext()<CR>
nnoremap <silent> L :<C-u>call LContext()<CR>
xnoremap <silent> H <ESC>:<C-u>call HContext()<CR>mzgv`z
xnoremap <silent> L <ESC>:<C-u>call LContext()<CR>mzgv`z

function! HContext()
  let l:moved = MoveCursor("H")
  if !l:moved && line('.') != 1
    " execute "normal! " . "\<ScrollWheelUp>H"
    execute "normal! " . "5kH"
  endif
endfunction

function! LContext()
  let l:moved = MoveCursor("L")

  if !l:moved && line('.') != line('$')
    " execute "normal! " . "\<ScrollWheelDown>L"
    execute "normal! " . "5jL"
  endif
endfunction

function! MoveCursor(key)
  let l:cnum = col('.')
  let l:lnum = line('.')
  let l:wline = winline()

  execute "normal! " . v:count1 . a:key
  let l:moved =
        \ l:cnum  != col('.')  ||
        \ l:lnum  != line('.') ||
        \ l:wline != winline()

  return l:moved
endfunction



" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker


