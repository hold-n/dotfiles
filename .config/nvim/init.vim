let mapleader = " "

" =============================================================================
" Plugins
" =============================================================================

call plug#begin(stdpath('data') . '/plugged')

if !exists('g:vscode')
  " --- Colorschemes ---
  Plug 'lisposter/vim-blackboard'
  Plug 'morhetz/gruvbox'
  let g:gruvbox_contrast_dark='hard'
  Plug 'rakr/vim-one'
  let g:one_allow_italics = 1
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'kkga/vim-envy'
  Plug 'dchinmay2/alabaster.nvim'
  Plug 'danilo-augusto/vim-afterglow'
  Plug 'ayu-theme/ayu-vim'
  Plug 'jaredgorski/SpaceCamp'
  Plug 'dikiaap/minimalist'

  " --- UI ---
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'mhinz/vim-startify'
  Plug 'nathanaelkane/vim-indent-guides'
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_guide_size = 1
  let g:indent_guides_start_level = 2
  Plug 'jmckiern/vim-venter'
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

  " --- File navigation ---
  Plug 'airblade/vim-rooter'

  " --- FZF ---
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction
  let $FZF_DEFAULT_OPTS='--reverse --bind ctrl-a:select-all'
  let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
    \}
  if executable('rg')
      let g:rg_derive_root='true'
  endif

  " --- Git ---
  Plug 'tpope/vim-fugitive'
  source $HOME/.config/nvim/fugitive-gitfarm.vim

  " --- Misc ---
  Plug 'mbbill/undotree'
  Plug 'shime/vim-livedown'
endif

" --- Treesitter ---
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'master'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch': 'master'}

" --- Editing ---
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'svermeulen/vim-cutlass'
Plug 'michaeljsmith/vim-indent-object'

" --- Misc ---
Plug 'kongo2002/fsharp-vim'

call plug#end()

" =============================================================================
" Appearance
" =============================================================================

if !exists('g:vscode')
  set termguicolors
  set background=dark
  colorscheme alabaster
  syntax enable
  set number relativenumber
  set cursorline
  set colorcolumn=90,125
  set signcolumn=yes
  set noshowmode
  set list
  set listchars=tab:→\ ,trail:·,extends:…,precedes:…,nbsp:␣
endif

" =============================================================================
" Editing
" =============================================================================

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set clipboard=unnamed
set nowrap
set foldmethod=expr
set foldexpr=v:lua.vim.treesitter.foldexpr()
set foldlevel=9999

" =============================================================================
" Search
" =============================================================================

set ignorecase
set smartcase
set inccommand=split
if !exists('g:vscode')
    set hlsearch
endif

" =============================================================================
" Performance & behavior
" =============================================================================

set updatetime=250
set scrolloff=5
set splitbelow
set lazyredraw
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set autoread

" =============================================================================
" Autocmds
" =============================================================================

" Trims trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

autocmd FileType markdown,log,txt setlocal wrap linebreak textwidth=100
autocmd CursorHold * checktime
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

" =============================================================================
" Keymaps
" =============================================================================

" --- Navigation ---
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>- :vertical resize -10<CR>
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>e <C-^>

" --- Search ---
nnoremap n nzzzv
nnoremap N Nzzzv

if !exists('g:vscode')
  " --- FZF ---
  nnoremap <C-p> :GFiles<CR>
  vnoremap <leader>fs "zy:BLines! <C-R>z<CR>
  vnoremap <leader>ws "zy:Rg! <C-R>z<CR>
  nnoremap <leader>ws :Rg <C-R>=expand("<cword>")<CR><CR>
  nnoremap <leader>fs :BLines!<CR>
  nnoremap <leader>gs :Rg!<CR>
  nnoremap <leader>fc :Commands!<CR>

  " --- Buffers ---
  nnoremap <leader>qb :bnext\|bdelete #<CR>
  nnoremap <C-n> :Buffers<CR>
endif

" --- Cutlass (x = cut) ---
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D

if !exists('g:vscode')
  " --- Plugins ---
  nnoremap <leader>u :UndotreeToggle<CR>
  nnoremap <leader>md :LivedownToggle<CR>
endif

" --- Editing ---
vnoremap <leader>p "_dP
nnoremap <leader>wr "zyiw:%s/<C-R>z//g<Left><Left>
vnoremap <leader>wr "zy:%s/<C-R>z//g<Left><Left>

" --- Quickfix ---
nnoremap <silent> <C-j> :cnext<CR>
nnoremap <silent> <C-k> :cprev<CR>

" Horizontally center cursor position.
nnoremap <silent> z. :<C-u>normal! zszH<CR>

" Format json
nnoremap <silent><leader>json :%!python3 -m json.tool<CR>
vnoremap <silent><leader>json :'<,'>!python3 -m json.tool<CR>

" =============================================================================
" LSP, Treesitter & Plugin configs (lua)
" =============================================================================

if !exists('g:vscode')
lua << EOF
-- LSP servers
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
  on_attach = function(client, bufnr)
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end,
})
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  on_attach = function(client, bufnr)
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end,
})
vim.lsp.enable({'ts_ls', 'pyright'})

-- LSP keymaps & completion
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
  end,
})

-- Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'python', 'typescript', 'javascript', 'java', 'lua', 'vim', 'vimdoc', 'markdown', 'bash', 'json', 'yaml' },
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { [']m'] = '@function.outer' },
      goto_previous_start = { ['[m'] = '@function.outer' },
    },
  },
})

-- Bufferline
require('bufferline').setup({
  options = {
    mode = 'buffers',
    numbers = 'buffer_id',
    max_name_length = 30,
    tab_size = 25,
    diagnostics = 'nvim_lsp',
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = 'slant',
    themable = true,
    pick = {
      alphabet = 'abcdefghijklmopqrstuvwxyz',
    },
  },
})
vim.keymap.set('n', '<C-l>', '<Cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', '<C-h>', '<Cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<C-b>', '<Cmd>BufferLinePick<CR>')

-- Lualine
require('lualine').setup()
EOF
endif
