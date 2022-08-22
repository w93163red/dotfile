" plugin list
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdcommenter'
Plug 'dyng/ctrlsf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'} 
Plug 'rafi/awesome-vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'liuchengxu/vista.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ciaranm/detectindent'
Plug 'mhinz/vim-startify'
Plug 'skywind3000/asyncrun.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()
" colorscheme
colorscheme base16-default-dark
" keymap
nnoremap <space>fT :CocCommand explorer --sources=buffer+,file+<CR>
" nnoremap <space>fT :NvimTreeToggle<CR>
nnoremap <space>fh :History<CR>
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
nmap <leader>cc   <Plug>NERDCommenterToggle
vmap <leader>cc   <Plug>NERDCommenterToggle<CR>gv
nnoremap ]b :bn!<CR>
nnoremap [b :bp!<CR>
nnoremap <space>b <cmd>Telescope buffers<CR>
nnoremap <leader>bd :BD<CR>
nnoremap <space>ss :CocCommand session.save<CR>
nnoremap <space>sl :CocCommand session.load<CR>
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_
" let g:Lf_ShortcutF = '<c-p>'
noremap <Tab> >>
nnoremap <s-tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <F6> :nohl<CR>
nnoremap <s-F6> :LspRename<CR>
inoremap jj <ESC>
" map <c-p> :FZF<CR>
nmap <C-F>f <Plug>CtrlSFPrompt
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
xnoremap p pgvy
if has('vim')
set <a-cr>=^[^M
endif
map <F8> :Vista!!<CR>
map <F5> :e!<CR>
tnoremap <Esc> <C-\><C-n>
" vim setting
filetype plugin on
syntax enable
set showcmd
set hidden
set smartindent
set incsearch
set hlsearch
set formatoptions-=cro
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
" set showtabline=2
set mouse=a
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=50
set synmaxcol=200
set scrolloff=5
set signcolumn=yes
set laststatus=2
set termguicolors
hi LineNr ctermbg=NONE guibg=NONE
" hi Pmenu ctermbg=NONE guibg=NONE
set nowrap
set signcolumn=yes
set encoding=utf-8
set vb t_vb= " No more beeps
set ttyfast
" set relativenumber
set number
" set cc=100
set nofoldenable
set autoread
au CursorHold * checktime
set shortmess+=c
set lazyredraw
set splitright
autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab
" save the last edit position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 
" Enable true color 启用终端24位色
if exists('+termguicolors')
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
endif
" " NerdTree
" " Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a
" region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
let g:nerdtree_tabs_autoclose = 1

" vim-clap
let g:clap_layout = { 'relative': 'editor' }
let g:clap_theme = 'material_design_dark'

" statuslin" lightline
" let g:lightline = {
"             \ 'colorscheme': 'one',
"             \ 'active': {
"             \   'left': [
"             \     [ 'mode', 'paste', 'buffers' ],
"             \     [ 'gitbranch', 'diagnostic', 'cocstatus', 'filename', 'currentfunction', 'readonly', 'modified', 'method']
"             \   ],
"             \   'right':[
"             \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent', 'blame']
"             \   ],
"             \ },
"             \ 'component_function': {
"             \   'cocstatus': 'coc#status',
"             \   'currentfunction': 'CocCurrentFunction',
"             \   'gitbranch': 'FugitiveHead',
"             \   'blame': 'LightlineGitBlame',
"             \ },
"             \ 'component_expand': {
"             \   'buffers': 'lightlinebufferline'
"             \ },
"             \ 'component_type': {
"             \   'buffers': 'tabsel'
"             \ }
"             \ }
"
" function! LightlineGitBlame() abort
"     let blame = get(b:, 'coc_git_blame', '')
"     " return blame
"     return winwidth(0) > 120 ? blame : ''
" endfunction

" CoC Language Server
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <cr> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() :
        \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>showDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
autocmd!
" Setup formatexpr specified filetype(s).
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" Update signature help on jump placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <leader>cl  <Plug>(coc-codelens-action)
" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <c-f> :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>

" fmt on save
let g:rustfmt_autosave=1
"autoindent
autocmd BufReadPost * :DetectIndent 

" git 
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
" nnoremap <space>gp :Git Push origin HEAD:refs/for/master<CR>

" airline
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#enabled = 0 "enable the tabline
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#fnamemod = 'default'
let g:airline_detect_modified=1
let g:airline#extensions#tabline#buffer_idx_format = {
      \ '0': '0 ',
      \ '1': '1 ',
      \ '2': '2 ',
      \ '3': '3 ',
      \ '4': '4 ',
      \ '5': '5 ',
      \ '6': '6 ',
      \ '7': '7 ',
      \ '8': '8 ',
      \ '9': '9 '
      \}
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" rust-ctags
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
" autocmd BufWritePost *.rs :AsyncRun! rusty-tags vi --quiet --start-dir="%:p:h"

"neovide
let g:neovide_cursor_vfx_mode = "pixiedust" 

" asyncrun
let g:asyncrun_status = ''
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])

" tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" coc-explorer
let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

let g:coc_global_extensions = ['coc-json', 'coc-explorer', 'coc-lists', 'coc-prettier', 'coc-actions', 'coc-rust-analyzer', 'coc-go']

" neovide
let g:neovide_refresh_rate=144
let g:neovide_cursor_animation_length=0
let g:neovide_cursor_trail_length=0
let g:neovide_cursor_antialiasing=v:true
let g:neovide_cursor_vfx_mode = v:false

" telescope
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <c-f> <cmd>Telescope live_grep<cr>


