" Key Conventions:
"
" Super
"   Open / close windows and tabs
"   TextMate keybindings
"
" Meta
"   Emacs style movement / editing
"   Special character insertion
"   Insert commands that stay in insert mode
"
" <Leader>
"   Command line shortcuts


""" Mapleader {{{1

" Transfer decrement-number to (nvoic)<M-x> to free (nvo)<C-x>
" Bind:   M-x =>   Ctrl-X
" Bind: v_M-x => v_Ctrl-X
" Bind: o_M-x => o_Ctrl-X
" Bind: i_M-x => i_Ctrl-\_Ctrl-N_Ctrl-X
" Bind: c_M-x => c_Ctrl-\_Ctrl-N_Ctrl-X
noremap <C-x> <NOP>
Mapall  <M-x> <C-x>

" Transfer shift-line-right to (ic)<4-]> to free (ic)<C-t>
" Transfer insert-mode-completions to (ic)<C-t> to free (ic)<C-x>
" Bind: i_4-]    => i_Ctrl-T
" Bind: c_4-]    => c_Ctrl-T
" Bind: i_Ctrl-T => i_Ctrl-X
" Bind: c_Ctrl-T => c_Ctrl-X
noremap! <C-t> <NOP>
noremap! <4-]> <C-t>
noremap! <C-x> <NOP>
noremap! <C-t> <C-x>

" Mapleader is available in all modes, and always returns to normal-mode
" Bind:   Ctrl-X =>   <Leader>
" Bind: v_Ctrl-X => v_<Leader>
" Bind: o_Ctrl-X => o_<Leader>
" Bind: i_Ctrl-X => i_Ctrl-\_Ctrl-N_<Leader>
" Bind: c_Ctrl-X => c_Ctrl-\_Ctrl-N_<Leader>
let g:mapleader = ''
map! <Leader> <C-\><C-N><Leader>

" REPLACE move-up-and-start-of-line (nvo)- with <LocalLeader>
" Bind:   - =>   <LocalLeader>
" Bind: v_- => v_<LocalLeader>
" Bind: o_- => o_<LocalLeader>
noremap - <NOP>
let g:maplocalleader = '-'


""" Ctrl-C as Escape {{{1

" Allow Ctrl-C, which is easily accessible from the home row, to be a complete
" replacement for the Escape key:
"
"   * Complete (don't cancel) visual block insertions
"   * Alway break out of Select mode
"
" Bind: v_Ctrl-C => v_Ctrl-\_Ctrl-N
" Bind: s_Ctrl-C => s_Ctrl-\_Ctrl-N
vnoremap <C-c> <C-\><C-n>
snoremap <C-c> <C-\><C-n>


""" Emacs: Ctrl-A (start-of-line) {{{1

" Transfer increment-number to (nvo)<M-a> to free (nvo)<C-a>
" Bind:   M-a =>   Ctrl-A
" Bind: v_M-a => v_Ctrl-A
" Bind: o_M-a => o_Ctrl-A
" Bind: i_M-a => i_Ctrl-\_Ctrl-N_Ctrl-A
" Bind: c_M-a => i_Ctrl-\_Ctrl-N_Ctrl-A
noremap <C-a> <NOP>
Mapall  <M-a> <C-a>

" Transfer insert-prev-text / insert-all-completions to (ic)<4-a> to free
" (ic)<C-a>
" Bind: i_4-a => i_Ctrl-A
" Bind: c_4-a => c_Ctrl-A
noremap! <C-a> <NOP>
noremap! <4-a> <C-a>

" Bind <C-a> to start-of-line in all modes
" Bind:   Ctrl-A => ^
" Bind: v_Ctrl-A => v_^
" Bind: o_Ctrl-A => o_^
" Bind: i_Ctrl-A => i_Ctrl-\_Ctrl-O_^
" Bind: c_Ctrl-A => c_Home
noremap  <C-a> ^
inoremap <C-a> <C-\><C-o>^
cnoremap <C-a> <Home>


""" Emacs: Ctrl-E (end-of-line) {{{1

" Transfer scroll-window-down to (nvo)<4-e> to free (nvo)<C-e>
" Bind:   4-e =>   Ctrl-E
" Bind: v_4-e => v_Ctrl-E
" Bind: o_4-e => o_Ctrl-E
noremap  <C-e> <NOP>
noremap  <4-e> <C-e>

" Transfer insert-character-below / revert-completion to (i)<4-e> to free
" (i)<C-e>. c_Ctrl-E is already bound to end-of-command-line.
" Bind: i_4-e => i_Ctrl-E / complete_Ctrl-E
inoremap <C-e> <NOP>
inoremap <4-e> <C-e>

" Bind <C-e> to end-of-line
" Bind:   Ctrl-E => $
" Bind: v_Ctrl-E => v_$
" Bind: o_Ctrl-E => o_$
" Bind: i_Ctrl-E => i_End
noremap  <C-e> $
inoremap <C-e> <End>


""" Emacs: Ctrl-Y (paste-unnamed-register) {{{1

" Transfer scroll-window-up, insert-character-above, accept-completion,
" and copy-modeless-selection to (nvoic)<4-y> to free (nvoic)<C-y>
" Bind:   4-y =>   Ctrl-Y
" Bind: v_4-y => v_Ctrl-Y
" Bind: o_4-y => o_Ctrl-Y
" Bind: i_4-y => i_Ctrl-Y / complete_Ctrl-Y
" Bind: c_4-y => c_Ctrl-Y
noremap  <C-y> <NOP>
noremap! <C-y> <NOP>
noremap  <4-y> <C-y>
noremap! <4-y> <C-y>

" Set (nvoic)<C-y> to paste-unnamed-register
" Bind:   Ctrl-Y =>   ""p
" Bind: v_Ctrl-Y => v_""p
" Bind: o_Ctrl-Y => o_""p
" Bind: i_Ctrl-Y => i_Ctrl-R_""p
" Bind: c_Ctrl-Y => c_Ctrl-R_""p
noremap  <C-y> ""p
noremap! <C-y> <C-r>"


""" Emacs: Ctrl-F Ctrl-B (page-{down,up}, char-{right,left}) {{{1

" Rebind scroll-page-{up,down} to also jump to the middle of the page
" Bind:   Ctrl-F =>   <PageDown>_M
" Bind: v_Ctrl-F => v_<PageDown>_M
" Bind: o_Ctrl-F => o_<PageDown>_M
" Bind:   Ctrl-B =>   <PageUp>_M
" Bind: v_Ctrl-B => v_<PageUp>_M
" Bind: o_Ctrl-B => o_<PageUp>_M
noremap <C-f> <PageDown>M
noremap <C-b> <PageUp>M

" REPLACE deprecated-Ctrl-B and start-of-command-line with char-left
" Bind: i_Ctrl-B => i_<Left>
" Bind: c_Ctrl-B => c_<Left>
noremap! <C-b> <Left>

" Transfer c-reindent-line and open-command-line-window to (ic)<4-;> to free
" (ic)<C-f> for char-right.
" Bind: i_4-; => i_Ctrl-F
" Bind: c_4-; => c_Ctrl-F
noremap! <C-f> <NOP>
noremap! <4-;> <C-f>

" Bind (ic)<C-f> to char-right
" Bind: i_Ctrl-F => i_<Right>
" Bind: c_Ctrl-F => c_<Right>
noremap! <C-f> <Right>

" Since c_4-; opens the command line window, map <4-;> to do the same in (nvo)
noremap <4-;> q:


""" Emacs: Ctrl-D (forward-delete) {{{1

" REPLACE scroll-half-page-down (nvo)<C-d> with forward-delete.
" Bind:   Ctrl-D =>   x
" Bind: v_Ctrl-D => v_x
" Bind: o_Ctrl-D => o_x
noremap <C-d> x

" Transfer shift-line-left to (i)<4-[> to free (i)<C-d>
" Bind: i_4-[ => i_Ctrl-D
inoremap <C-d> <NOP>
inoremap <4-[> <C-d>

" Transfer list-pattern-matches to (c)<4-[> to free (c)<C-d>
" Bind: c_4-[ => c_Ctrl-D
cnoremap <C-d> <NOP>
cnoremap <4-[> <C-d>

" Set (ic)<C-d> as forward-delete
" Bind: i_Ctrl-D => i_Del
" Bind: c_Ctrl-D => c_Del
noremap! <C-d> <Del>


""" Emacs: Ctrl-K Ctrl-U (kill-to-{end,start}-of-line) {{{1

" Transfer enter-digraph to (nvoic)<M-\> to free (nvoic)<C-k>
" Bind:   <M-\> =>   Ctrl-K
" Bind: v_<M-\> => v_Ctrl-K
" Bind: o_<M-\> => o_Ctrl-K
" Bind: i_<M-\> => i_Ctrl-K
" Bind: c_<M-\> => c_Ctrl-K
noremap  <C-k> <NOP>
noremap  <M-\> <C-k>
noremap! <C-k> <NOP>
noremap! <M-\> <C-k>

" Set (nvoic)<C-k> to kill-to-end-of-line
" Bind:   Ctrl-K => D
" Bind: v_Ctrl-K => v_D
" Bind: o_Ctrl-K => o_D
" Bind: i_Ctrl-K => i_Ctrl-\_Ctrl-O_D
" Bind: c_Ctrl-K => c_Ctrl-F_D_Ctrl-C_<Right>
noremap  <C-k> D
inoremap <C-k> <C-\><C-o>D
cnoremap <C-k> <C-f>D<C-c><Right>

" REPLACE scroll-half-page-up and delete-all-inserted-chars with a simple
" kill-to-start-of-line. c_Ctrl-U already does this on the command line.
" Bind:   Ctrl-U => d^
" Bind: v_Ctrl-U => v_d^
" Bind: o_Ctrl-U => o_d^
" Bind: i_Ctrl-U => i_Ctrl-\_Ctrl-O_d^
noremap  <C-u> d^
inoremap <C-u> <C-\><C-o>d^


""" Emacs: Meta-f Meta-b Meta-d (word-{right,left} forward-delete-word) {{{1

" Word-right
noremap  <M-f> w
inoremap <M-f> <C-\><C-o>w
cnoremap <M-f> <S-Right>

" Word-left
noremap  <M-b> b
inoremap <M-b> <C-\><C-o>b
cnoremap <M-b> <S-Left>

" Forward-delete-word
noremap  <M-d> de
inoremap <M-d> <C-\><C-o>de
cnoremap <M-d> <C-f>de<C-c>


""" Command line and Search {{{1

" Transfer repeat-last-char-search to (nvo), to free (nvo);
" REPLACE (nvo), with nothing
" Bind:   , =>   ;
" Bind: v_, => v_;
" Bind: o_, => o_;
noremap ; <NOP>
noremap , ;

" Alias (nvo); to (nvo): for quick access to the command line
" Bind:   ; =>   :
" Bind: v_; => v_:
" Bind: o_; => o_:
noremap ; :

" SWAP c_Ctrl-n and c_<Down>, c_Ctrl-p and c_<Up>
cnoremap <C-n>  <Down>
cnoremap <Down> <C-n>
cnoremap <C-p>  <Up>
cnoremap <Up>   <C-p>

" Transfer go-to-column to (nvo)g| to free (nvo)|
" Bind:   g| =>   |
" Bind: v_g| => v_|
" Bind: o_g| => o_|
noremap <Bar>  <NOP>
noremap g<Bar> <Bar>

" Remap search commands to prepend magic / non-magic modifier
noremap /        /\v
noremap ?        ?\v
noremap <Bslash> /\V
noremap <Bar>    ?\V

" Center on next match (normal-mode only)
nnoremap n nzz
nnoremap N Nzz

" Simple command line aliases
noremap <Leader>h     :<C-u>help<Space>
noremap <Leader>C     :<C-u>colorscheme<Space>
noremap <Leader>!     :<C-u>make!<CR>
noremap <Leader><C-t> :<C-u>execute 'silent! !ctags -R' \| redraw! \| echo 'ctags -R'<CR>
noremap <4-p>         :<C-u>SynStack<CR>

" Clear last match
noremap <Leader><Bslash> :<C-u>let @/ = ''<CR>

" Run file
noremap <Leader>r :<C-u>RunCurrentFile<CR>


""" Buffer commands {{{1

" Save / Quit Buffer
Mapall <4-s>   :<C-u>update<CR>
Mapall <4-S>   :<C-u>write !sudo tee % >/dev/null<CR>
Mapall <4-\>   :<C-u>quit<CR>
Mapall <4-Bar> :<C-u>quit!<CR>

" REPLACE ex-mode with nothing to alias (n)Q as :quit
nnoremap Q :quit<CR>

" Settings and Toggles
noremap <Leader>s<Space> :<C-u>setlocal<Space>
noremap <Leader>sf       :<C-u>setlocal foldmethod=manual
noremap <Leader>?sf      :<C-u>setlocal foldmethod?<CR>
noremap <Leader>sm       :<C-u>setlocal synmaxcol=1000
noremap <Leader>?sm      :<C-u>setlocal synmaxcol?<CR>
noremap <Leader>st       :<C-u>SetTextwidth<Space>
noremap <Leader>?st      :<C-u>SetTextwidth<CR>
noremap <Leader>sw       :<C-u>SetWhitespace<Space>
noremap <Leader>?sw      :<C-u>SetWhitespace<CR>
noremap <Leader>~        :<C-u>setlocal spell! \| setlocal spell?<CR>
noremap <Leader><C-a>    :<C-u>SetAutowrap! \| SetAutowrap<CR>
noremap <Leader><C-b>    :<C-u>setlocal scrollbind! \| setlocal scrollbind?<CR>
noremap <Leader><C-d>    :<C-u>execute &diff ? 'diffoff' : 'diffthis' \| setlocal diff?<CR>
noremap <Leader><C-e>    :<C-u>setlocal expandtab! \| setlocal expandtab?<CR>
noremap <Leader><C-h>    :<C-u>setlocal hlsearch! \| setlocal hlsearch?<CR>
noremap <Leader><C-i>    :<C-u>SetIskeyword! \| SetIskeyword<CR>
noremap <Leader><C-l>    :<C-u>setlocal list! \| setlocal list?<CR>
noremap <Leader><C-o>    :<C-u>setlocal cursorline! \| setlocal cursorcolumn!<CR>
noremap <Leader><C-p>    :<C-u>setlocal paste! \| setlocal paste?<CR>
noremap <Leader><C-w>    :<C-u>setlocal wrap! \| setlocal wrap?<CR>

" Open frequently edited files
noremap <Leader>e<Space> :<C-u>tabedit<Space>
noremap <Leader>ea       :<C-u>execute 'TabOpen ' . resolve(expand('~/.vim/local/autocommands.vim'))<CR>
noremap <Leader>eb       :<C-u>execute 'TabOpen ' . resolve(expand('~/.bashrc'))<CR>
noremap <Leader>ec       :<C-u>execute 'TabOpen ' . resolve(expand('~/.vim/local/commands.vim'))<CR>
noremap <Leader>ee       :<C-u>edit<CR>
noremap <Leader>ei       :<C-u>execute 'TabOpen ' . resolve(expand('~/.inputrc'))<CR>
noremap <Leader>el       :<C-u>execute 'TabOpen ' . resolve(expand('~/.bashrc.d/local.bash'))<CR>
noremap <Leader>em       :<C-u>execute 'TabOpen ' . resolve(expand('~/.vim/local/mappings.vim'))<CR>
noremap <Leader>eM       :<C-u>execute 'TabOpen ' . resolve(expand('~/.vim/local/modifiers.vim'))<CR>
noremap <Leader>en       :<C-u>TabOpen /opt/nginx/etc/nginx.conf<CR>
noremap <Leader>eo       :<C-u>Org<CR>
noremap <Leader>er       :<C-u>TabOpen /etc/rc.conf<CR>
noremap <Leader>es       :<C-u>tabnew \| Scratch<CR>
noremap <Leader>eS       :<C-u>vnew \| wincmd L \| Scratch<CR>
noremap <Leader>et       :<C-u>Org TODO<CR>
noremap <Leader>eT       :<C-u>execute 'TabOpen ' . resolve(expand('~/.tmux.conf'))<CR>
noremap <Leader>eu       :<C-u>execute 'TabOpen ' . resolve($cdhaus . '/share/doc/unicode-table.txt.gz')<CR>
noremap <Leader>ev       :<C-u>execute 'TabOpen ' . resolve(expand($MYVIMRC))<CR>
noremap <Leader>ew       :<C-u>execute 'TabOpen ' . resolve(expand('~/.xmonad/xmonad.hs'))<CR>
noremap <Leader>ex       :<C-u>execute 'TabOpen ' . resolve(expand('~/.Xdefaults'))<CR>
noremap <Leader>eX       :<C-u>execute 'TabOpen ' . expand('~/.xinitrc')<CR>

" Set filetype
noremap <Leader>f<Space> :<C-u>setlocal filetype=
noremap <Leader>f?       :<C-u>setlocal filetype?<CR>
noremap <Leader>fc       :<C-u>setlocal filetype=c<CR>
noremap <Leader>fC       :<C-u>setlocal filetype=clojure<CR>
noremap <Leader>fd       :<C-u>setlocal filetype=diff<CR>
noremap <Leader>fh       :<C-u>setlocal filetype=html<CR>
noremap <Leader>fH       :<C-u>setlocal filetype=haskell<CR>
noremap <Leader>fj       :<C-u>setlocal filetype=javascript<CR>
noremap <Leader>fm       :<C-u>setlocal filetype=mail<CR>
noremap <Leader>fM       :<C-u>setlocal filetype=markdown<CR>
noremap <Leader>fo       :<C-u>setlocal filetype=org<CR>
noremap <Leader>fp       :<C-u>setlocal filetype=plain<CR>
noremap <Leader>fr       :<C-u>setlocal filetype=ruby<CR>
noremap <Leader>fs       :<C-u>setlocal filetype=sh<CR>
noremap <Leader>fv       :<C-u>setlocal filetype=vim<CR>
noremap <Leader>fy       :<C-u>setlocal filetype=yaml<CR>


""" Windows and Tabs {{{1

" Window focus / position
for [g:lhs, g:rhs] in [['Left', 'h'], ['Down', 'j'], ['Up', 'k'], ['Right', 'l']]
    execute 'Mapall <4-'   . g:lhs . '> :<C-u>wincmd ' . g:rhs .          '<CR>'
    execute 'Mapall <4-S-' . g:lhs . '> :<C-u>wincmd ' . toupper(g:rhs) . '<CR>'
endfor
for g:lhs in ['h', 'j', 'k', 'l']
    execute 'Mapall <4-' . g:lhs          . '> :<C-u>wincmd ' . g:lhs          . '<CR>'
    execute 'Mapall <4-' . toupper(g:lhs) . '> :<C-u>wincmd ' . toupper(g:lhs) . '<CR>'
endfor
unlet g:lhs g:rhs

" Window capture / breakout
Mapall  <4-O>  :<C-u>execute winnr('$') == 1 ? 'tabonly' : 'only'<CR>
noremap <C-w>! :<C-u>wincmd T<CR>
noremap <C-w>@ :<C-u>CapturePane<CR>

" Tabs
Mapall <4-t> :<C-u>tabnew<CR>
Mapall <4-T> :<C-u>tabnew<CR>
Mapall <4-{> :<C-u>tabprevious<CR>
Mapall <4-}> :<C-u>tabnext<CR>
Mapall <4-_> :<C-u>execute 'tabmove ' . (tabpagenr()-2)<CR>
Mapall <4-+> :<C-u>execute 'tabmove ' . tabpagenr()<CR>

" Quickfix window
Mapall <4-x> :<C-u>ToggleQuickfixWindow<CR>

" Close Preview window
Mapall <4-X> :<C-u>pclose<CR>

" Open URLs
Mapall <4-U> :<C-u>Open<CR>


""" Text editing {{{1

" Map Unicode character bindings from ~/.inputrc
MapReadlineUnicodeBindings

" Insert other special characters
nnoremap <M-CR> i\n<<C-\><C-n><Right>
vnoremap <M-CR> c\n<C-\><C-n>v
noremap! <M-CR> \n
noremap  <4-CR> A;<C-\><C-n>
inoremap <4-CR> <C-\><C-o>A;
cnoremap <4-CR> <End>;

" Backward-delete-word
noremap  <M-BS> db
noremap! <M-BS> <C-w>

" REPLACE switch-keyboard-language with nothing to alias (nvoi)<C-_>
" as undo-and-return-to-normal-mode
noremap  <C-_> :<C-u>undo<CR>
inoremap <C-_> <C-\><C-n><C-_>

" Forward-change-case
noremap <M-u> guWW
map!    <M-u> <C-\><C-o>guW<C-\><C-o>W
noremap <M-U> gUWW
map!    <M-U> <C-\><C-o>gUW<C-\><C-o>W

" Join lines
noremap  <Leader><C-j> J
inoremap <Leader><C-j> <C-\><C-o>J

" Select all
nnoremap <4-a> VggoG
vnoremap <4-a> <C-\><C-n>VggoG

" Kill trailing whitespace
noremap <silent> <Leader><C-k> :<C-u>let b:__reg_slash__ = @/<CR>m`:%s/\v[ \t\r]+$//e<CR>:let @/ = b:__reg_slash__ \| unlet b:__reg_slash__<CR>``

" REPLACE insertmode-go-to-normal-mode and command-line-insert-longest-match
" with nothing for hashrocket
noremap! <C-l> <Space>=><Space>

" Indent lines (à la TextMate)
nnoremap <4-[> a<C-d><C-\><C-n>
nnoremap <4-]> a<C-t><C-\><C-n>
vnoremap <4-[> <gv
vnoremap <4-]> >gv

" http://vim.wikia.com/wiki/Moving_lines_up_or_down
nnoremap <M-j> :move+<CR>==
nnoremap <M-k> :move-2<CR>==
inoremap <M-j> <C-\><C-n>:move+<CR>==gi
inoremap <M-k> <C-\><C-n>:move-2<CR>==gi
vnoremap <M-j> :move'>+<CR>gv=gv
vnoremap <M-k> :move-2<CR>gv=gv

" http://vim.wikia.com/wiki/Drag_words_with_Ctrl-left/right
vnoremap <M-h> <C-\><C-n>`<<Left>i_<C-\><C-n>mz"_xgvx`zPgv<Left>o<Left>o
vnoremap <M-l> <C-\><C-n>`><Right>gvxpgv<Right>o<Right>o

" Definitions / Etymology / Google
for [g:lhs, g:rhs] in [['D', 'http://dictionary.reference.com/browse/'],
                     \ ['E', 'http://www.etymonline.com/index.php?search='],
                     \ ['G', 'https://encrypted.google.com/search?pws=0&tbs=li:1&q='],
                     \ ['H', 'http://symbolhound.com/?q=']]
    let g:fmt = 'noremap <Leader>' . g:lhs . ' :<C-u>execute "silent! ! open ' . shellescape(g:rhs) . '" . shellescape(CwordOrSel(%d)) \| redraw!<CR>'
    execute 'n' . printf(g:fmt, 0)
    execute 'v' . printf(g:fmt, 1)
endfor
unlet g:lhs g:rhs g:fmt

" REPLACE move-down-and-start-of-line with a simple add-numbers-in-selection
vnoremap + "ry:ruby
    \ r = VIM.evaluate('@r').scan(/[+-]?\d+(?:\.\d+)?/).flatten.inject(0) { \|s,n\| s + n.to_f };
    \ VIM.command(%q(let @r = "%f") % r);
    \ print r<CR>


""" Plugins {{{1

" Plugin: surround.vim - visual surround shortcuts (a la TextMate)
" REPLACE (v)( sentence-backward and (v)' jump-to-mark with surrounds.
" RECURSIVE map for <Plug> mappings.
vmap ( <Plug>VSurround(
vmap ' <Plug>VSurround'

" Plugin: Shebang
noremap <Leader>fx :<C-u>silent! call SetExecutable() \| :redraw!<CR>

" Plugin: Fugitive (git) + Gitv - remember to update readline macros
noremap  <Leader>g<Space> :<C-u>Git<Space>
noremap  <Leader>gb       :Gblame<CR>
noremap  <Leader>gB       :Gbrowse<CR>
noremap  <Leader>gc       :<C-u>Gcommit<CR>
noremap  <Leader>gd       :<C-u>Git di<CR>
noremap  <Leader>gD       :<C-u>Gdiff<Space>
noremap  <Leader>g%       :<C-u>Git di %<CR>
noremap  <Leader>gf       :<C-u>silent! Git f<CR>
noremap  <Leader>gl       :<C-u>silent! Git lp<CR>
noremap  <Leader>gL       :<C-u>Glog<CR>
noremap  <Leader>gr       :<C-u>silent! Git rs<CR>
noremap  <Leader>gv       :Gitv<CR>
noremap  <Leader>gV       :Gitv!<CR>
noremap  <Leader>gaa      :<C-u>silent! Git aa<CR>
noremap  <Leader>gac      :<C-u>silent! Git aa \| Gcommit<CR>
noremap  <Leader>gap      :<C-u>Git ap<CR>
noremap  <4-g>            :<C-u>Gstatus<CR>
noremap  <4-G>            q:iGgrep! -Pi<Space>
nnoremap <4-8>            :<C-u>let @/ = CwordOrSel(0) \| execute 'silent! Ggrep! -F ' . @/ \| redraw!<CR>
vnoremap <4-8>            :<C-u>let @/ = CwordOrSel(1) \| execute 'silent! Ggrep! -F ' . @/ \| redraw!<CR>

" Plugin: ScreenShell
noremap <Leader>S :<C-u>Screen<CR>

" Plugin: Manpageview
noremap <Leader>K viwK
noremap <Leader>m :<C-u>VMan<Space>
noremap <Leader>M :<C-u>HMan<Space>

" Plugin: Align
noremap <Leader>a<Space> :Align<Space>
noremap <Leader>a.       :Align \.<CR>
noremap <Leader>a<C-l>   :Align =><CR>

" Plugin: NrrwRgn
nnoremap <Leader>nr vip:NarrowRegion<CR>

" Plugin: operator-camelize
" RECURSIVE map for <Plug> mappings
nmap <Leader>- viw<Plug>(operator-camelize-toggle)
vmap <Leader>- <Plug>(operator-camelize-toggle)

" Plugin: Command-T
Mapall <4-o> :<C-u>CommandT<CR>
Mapall <4-t> :<C-u>tabnew \\\| CommandT<CR>
Mapall <4-'> :<C-u>CommandTTag<CR>
Mapall <4-.> :<C-u>CommandTJump<CR>
Mapall <4-b> :<C-u>CommandTBuffer<CR>
Mapall <4-B> :<C-u>CommandTFlush<CR>
Mapall <4-V> :<C-u>vsplit \\\| wincmd l \\\| CommandT<CR>

" Plugin: NERDTree
Mapall <4-d> :<C-u>NERDTreeToggle<CR>
Mapall <4-D> :<C-u>NERDTreeFind<CR>

" Plugin: Ack.vim
Mapall <4-A> q:iAck!<Space>

" Plugin: Gundo
Mapall <4-u> :GundoToggle<CR>

" Plugin: Regbuf
Mapall <4-r> :RegbufOpen<CR>

" Plugin: UltiSnips
Mapall <4-F> :<C-u>UltiSnipsEdit<CR>

" Plugin: Tagbar
Mapall <4-i> :<C-u>TagbarToggle<CR>
Mapall <4-I> :<C-u>TagbarOpen<CR>

" Plugin: NERD_commenter
map  <4-/> <Plug>NERDCommenterToggleAlign
map! <4-/> <C-\><C-n><Plug>NERDCommenterToggleAlign

" Plugin: CamelCaseMotion
map  <C-Left>  <Plug>CamelCaseMotion_b
map! <C-Left>  <C-\><C-o><C-Left>
map  <C-Right> <Plug>CamelCaseMotion_e
map! <C-Right> <C-\><C-o><C-Right>
map  <C-BS>    d<Plug>CamelCaseMotion_b
map! <C-BS>    <C-\><C-o><C-BS>
