if !exists('g:vscode') 
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
  lua <<EOF
  require'bufferline'.setup{
    options = {
      offsets = {
        {
            filetype = "coc-explorer",
            text = function()
            return vim.fn.getcwd()
          end,
          highlight = "Directory",
          text_align = "left"
        }
      }
    }

  }
EOF
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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", "rust", "cpp", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
  enable = true,              -- false will disable the whole extension
  additional_vim_regex_highlighting = false,
  },
}

require'nvim-tree'.setup()
EOF
