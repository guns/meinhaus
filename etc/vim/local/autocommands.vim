""" Autocommands

augroup GUNS
    autocmd!

    " From vimrc_example.vim: {{{1
    " When editing a file, always jump to the last known cursor position.  Don't
    " do it when the position is invalid or when inside an event handler (happens
    " when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

    " Remove 'o' from formatoptions because every damn ftplugin sets it
    autocmd FileType *
        \ setlocal formatoptions-=o

    " :help ft-syntax-omni {{{1
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
            \ if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
    endif

    " Quickfix / Location List
    autocmd QuickFixCmdPost *
        \ cwindow | topleft lwindow
    autocmd FileType qf
        \ execute 'noremap <buffer> <C-l> :<C-u>call setqflist([]) \| call setloclist(0, []) \| quit<CR>'

    " Vimscript {{{1
    autocmd FileType vim
        \ setlocal foldmethod=expr foldexpr=VimFoldExpr(v:lnum)
    autocmd FileType help
        \ setlocal foldmethod=expr foldexpr=VimHelpFoldExpr(v:lnum) iskeyword+=-
    autocmd BufRead /tmp/verbose.vim
        \ silent! :%s/\V^I/	/g
    autocmd BufRead /tmp/profile.vim
        \ silent! :%s/\v[ \t\r]+$//

    " Diff {{{1
    autocmd FileType diff,git,gitcommit
        \ setlocal foldmethod=expr foldexpr=DiffFoldExpr(v:lnum) |
        \ SetWhitespace 8

    " gitcommit {{{1
    autocmd FileType gitcommit
        \ setlocal iskeyword+=- foldmethod=expr foldexpr=DiffFoldExpr(v:lnum) |
        \ SetTextwidth 72 |
        \ SetAutowrap 1

    " Shell {{{1
    autocmd BufRead,BufNewFile *profile,rc.conf,PKGBUILD,/etc/netctl/*
        \ setlocal filetype=sh
    autocmd FileType sh
        \ setlocal iskeyword+=- foldmethod=expr foldexpr=ShellFoldExpr(v:lnum)

    " Lisp {{{1
    autocmd BufRead,BufNewFile *.el
        \ setlocal filetype=lisp
    autocmd FileType emacs-lisp
        \ setlocal filetype=lisp
    autocmd BufRead,BufNewFile *.cljx
        \ setlocal filetype=clojure
    autocmd Filetype lisp,scheme,clojure
        \ LispBufferSetup

    " Ruby {{{1
    autocmd BufRead,BufNewFile *irbrc,*pryrc,config.ru,Gemfile
        \ setlocal filetype=ruby
    autocmd BufRead,BufNewFile *Rakefile
        \ setlocal filetype=ruby foldmethod=expr foldexpr=RakefileFoldExpr(v:lnum)
    autocmd FileType ruby,eruby
        \ setlocal makeprg=rake iskeyword+=? iskeyword+=! |
        \ setlocal foldmethod=expr foldexpr=RubyFoldExpr(v:lnum) |
        \ execute 'noremap  <buffer> <Leader>R :<C-u>RunCurrentMiniTestCase<CR>' |
        \ execute 'noremap! <buffer> <C-l>     <Space>=><Space>' |
        \ SetWhitespace 2 8
    " Metasploit doesn't follow community conventions
    autocmd BufRead,BufNewFile $cdmetasploit/*
        \ setlocal noexpandtab |
        \ SetWhitespace 4 8

    " Python {{{1
    autocmd FileType python
        \ SetWhitespace 4 8

    " PHP {{{1
    autocmd FileType php
        \ SetWhitespace 2 8

    " Haskell {{{1
    autocmd FileType haskell
        \ SetWhitespace 2 8

    " X?HTML/XML {{{1
    autocmd FileType html,xhtml,xml
        \ setlocal synmaxcol=500 iskeyword+=- |
        \ SetWhitespace 2 8

    " HAML/SASS/YAML {{{1
    autocmd FileType haml,sass,yaml
        \ setlocal iskeyword+=- |
        \ SetWhitespace 2 8
    autocmd FileType haml
        \ execute 'noremap  <buffer> <M-CR> i%br<C-\><C-o><C-\><C-n>' |
        \ execute 'noremap! <buffer> <M-CR> %br' |
        \ execute 'noremap! <buffer> <C-l>  <Space>=><Space>'

    " CSS {{{1
    autocmd FileType css
        \ setlocal iskeyword+=- |
        \ SetWhitespace 4 8
    autocmd BufRead,BufNewFile *.less
        \ setlocal filetype=sass |
        \ SetWhitespace 4 8

    " JavaScript {{{1
    autocmd FileType javascript
        \ execute 'let b:jslint_disabled = 1' |
        \ execute 'noremap <buffer> <Leader><C-l> :JSLintToggle<CR>' |
        \ setlocal tags+=./.jstags,.jstags |
        \ SetWhitespace 2 8
    autocmd FileType coffee
        \ SetWhitespace 2 8

    " C {{{1
    autocmd FileType c,c++
        \ setlocal foldmethod=expr foldexpr=CFoldExpr(v:lnum) cinoptions=:0

    " Nginx {{{1
    autocmd BufRead,BufNewFile */nginx/etc/*.conf,nginx.conf
        \ setlocal filetype=nginx
    autocmd FileType nginx
        \ setlocal iskeyword-=. iskeyword-=/ iskeyword-=: iskeyword+=- |
        \ SetWhitespace 4 8

    " Ini conf gitconfig {{{1
    autocmd BufRead,BufNewFile *gitconfig
        \ setlocal filetype=gitconfig
    autocmd FileType ini,gitconfig
        \ SetWhitespace 4 8

    " Apache {{{1
    autocmd FileType apache
        \ SetWhitespace 4 8

    " XDefaults {{{1
    autocmd BufRead,BufNewFile *Xdefaults
        \ setlocal filetype=xdefaults

    " UltiSnips snippets {{{1
    autocmd FileType snippets
        \ setlocal noexpandtab iskeyword+=- foldmethod=marker |
        \ SetWhitespace 8

    " Markdown {{{1
    autocmd FileType markdown,rdoc
        \ setlocal iskeyword+=- foldmethod=expr foldexpr=MarkdownFoldExpr(v:lnum) |
        \ SetWhitespace 4 8

    " Mail {{{1
    autocmd BufRead,BufNewFile *.mail
        \ setlocal filetype=mail
    autocmd BufRead,BufNewFile vimperator-*
        \ setlocal filetype=mail |
        \ SetAutowrap 0 |
        \ setlocal wrap
    autocmd FileType mail
        \ setlocal iskeyword+=- |
        \ SetTextwidth 72 |
        \ SetWhitespace 4 8 |
        \ SetAutowrap 1

    " Mutt {{{1
    autocmd BufRead,BufNewFile ~/.mutt/*rc,/opt/haus/etc/%mutt/muttrc*
        \ setlocal filetype=muttrc

    " Archive browsing {{{1
    autocmd BufReadCmd *.jar,*.xpi,*.pk3
        \ call zip#Browse(expand("<amatch>"))
    autocmd BufReadCmd *.gem
        \ call tar#Browse(expand("<amatch>"))

    " tmux {{{1
    autocmd BufRead,BufNewFile *tmux.conf
        \ setlocal filetype=tmux |
        \ SetWhitespace 4 8

    " screen {{{1
    autocmd BufRead,BufNewFile *screenrc
        \ setlocal filetype=screen

    " http logs {{{1
    autocmd BufRead *access.log*
        \ setlocal filetype=httplog

    " dnsmasq {{{1
    autocmd BufRead,BufNewFile dnsmasq.conf*
        \ setlocal filetype=dnsmasq

    " Applescript (which sucks) {{{1
    autocmd BufRead,BufNewFile *.applescript
        \ setlocal filetype=applescript

    " Readline {{{1
    autocmd BufRead,BufNewFile *inputrc,*inputrc.d/*
        \ SetIskeyword! |
        \ setlocal filetype=readline foldmethod=expr foldexpr=ShellFoldExpr(v:lnum)

    " Nethack! {{{1
    autocmd BufRead,BufNewFile *.des
        \ setlocal filetype=nhdes

    " TeX {{{1
    autocmd FileType tex
        \ setlocal iskeyword+=\\ iskeyword+=- |
        \ SetWhitespace 2 8

    " CTags {{{1
    autocmd BufRead,BufNewFile .tags
        \ setlocal filetype=tags

    " Man pages {{{1
    autocmd FileType man
        \ SetIskeyword!

    " Terminfo {{{1
    autocmd BufRead,BufNewFile *.terminfo
        \ setlocal filetype=terminfo

    " vim-orgmode {{{1
    autocmd FileType org
        \ OrgBufferSetup

    " systemd {{{1
    autocmd BufNewFile,BufRead *.automount,*.mount,*.path,*.service{,.erb},*.socket,*.swap,*.target,*.timer,
        \ set filetype=systemd

    " PostgreSQL {{{1
    autocmd BufRead,BufNewFile psql.edit.*
        \ setlocal filetype=sql

    " Plugin: Unite.vim {{{1
    autocmd FileType unite
        \ syntax clear Tab TrailingWS |
        \ let b:loaded_delimitMate = 1 |
        \ BufReMapall <4-Bslash> <Plug>(unite_all_exit) |
        \ nmap <silent><buffer><expr> <Space> unite#smart_map("\<Plug>(unite_choose_action)", "\<Plug>(unite_toggle_mark_current_candidate)") |
        \ imap <silent><buffer><expr> <Space> unite#smart_map("\<Plug>(unite_choose_action)", "\<Plug>(unite_toggle_mark_current_candidate)")

" }}}1
augroup END
