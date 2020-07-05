if !exists('g:vscode') 
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath = &runtimepath
	source ~/.vimrc
else
	nnoremap ]b :bn!<CR>
	nnoremap [b :bp!<CR>
	nnoremap H ^
	nnoremap L $	
	vnoremap H ^
	vnoremap L $
	nnoremap <Tab> >>
	nnoremap <s-tab> <<
	vnoremap <Tab> >gv
	vnoremap <S-Tab> <gv
	nnoremap <F6> :nohl<CR>
    vmap <Leader>y "+y
	vmap <Leader>d "+d
	nmap <Leader>p "+p
	nmap <Leader>P "+P
	vmap <Leader>p "+p
	vmap <Leader>P "+P
	xnoremap p pgvy
	xmap <C-_>  <Plug>VSCodeCommentary
	nmap <C-_>  <Plug>VSCodeCommentary
	omap <C-_>  <Plug>VSCodeCommentary
	nmap gcc <Plug>VSCodeCommentaryLine
endif