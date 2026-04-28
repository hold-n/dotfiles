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
  Plug 'shortcuts/no-neck-pain.nvim'
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

  " --- File navigation ---
  Plug 'airblade/vim-rooter'
  Plug 'stevearc/oil.nvim'

  " --- FFF ---
  Plug 'dmtrKovalenko/fff.nvim'

  " --- FZF (buffers only) ---
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  nnoremap <C-n> :Buffers<CR>

  " --- Misc ---
  Plug 'mbbill/undotree'
  nnoremap <leader>u :UndotreeToggle<CR>
  Plug 'shime/vim-livedown'
  nnoremap <leader>md :LivedownToggle<CR>
endif

" --- Git ---
Plug 'tpope/vim-fugitive'

" --- Treesitter ---
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'main'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'branch': 'main'}

" --- Editing ---
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'svermeulen/vim-cutlass'
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D
Plug 'michaeljsmith/vim-indent-object'

" --- Misc ---
Plug 'kongo2002/fsharp-vim'

call plug#end()

source $HOME/.config/nvim/fugitive-gitfarm.vim

" =============================================================================
" Appearance
" =============================================================================

if !exists('g:vscode')
  set termguicolors
  set background=light
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
if !exists('g:vscode')
    set hlsearch
endif

" =============================================================================
" Performance & behavior
" =============================================================================

set updatetime=250
set scrolloff=5
set splitbelow
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
  " --- Buffers ---
  nnoremap <leader>qb :bnext\|bdelete #<CR>
  nnoremap <C-n> :Buffers<CR>
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
" Plugin configs (lua)
" =============================================================================

if !exists('g:vscode')
lua << EOF
-- LSP
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
require('nvim-treesitter').setup()
require('nvim-treesitter').install({ 'python', 'typescript', 'javascript', 'java', 'lua', 'vim', 'vimdoc', 'markdown', 'bash', 'json', 'yaml' })
local ts_filetypes = { 'python', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'java', 'lua', 'vim', 'markdown', 'bash', 'json', 'yaml' }
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})
vim.keymap.set({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end)

-- Oil
require('oil').setup()
vim.keymap.set('n', '-', '<CMD>Oil<CR>')

-- FFF
local fff_dl = require('fff.download')
if not vim.uv.fs_stat(fff_dl.get_binary_path()) then
  fff_dl.download_or_build_binary()
end
require('fff').setup()
vim.keymap.set('n', '<C-p>', function() require('fff').find_files() end)
vim.keymap.set('n', '<leader>gs', function() require('fff').live_grep() end)
vim.keymap.set('n', '<leader>ws', function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end)
vim.keymap.set('v', '<leader>ws', function()
  vim.cmd('noau normal! "zy')
  require('fff').live_grep({ query = vim.fn.getreg('z') })
end)

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

-- No Neck Pain
local nnp_profiles = {
  coding = { width = 160, buffers = { right = { enabled = false }, left = { enabled = true } }, integrations = { undotree = { position = "left" } } },
  notes  = { width = 120,  buffers = { right = { enabled = true },  left = { enabled = true } }, integrations = { undotree = { position = "left" } } },
}
local function nnp_apply(name)
  local cfg = nnp_profiles[name]
  if not cfg then return end
  local nnp = require('no-neck-pain')
  vim.cmd('NoNeckPain')
  nnp.setup(cfg)
  vim.cmd('NoNeckPain')
end
vim.api.nvim_create_user_command('NNPCoding', function() nnp_apply('coding') end, {})
vim.api.nvim_create_user_command('NNPNotes',  function() nnp_apply('notes') end, {})
require('no-neck-pain').setup(nnp_profiles.coding)
vim.keymap.set('n', '<leader>np', '<Cmd>NoNeckPain<CR>')
vim.keymap.set('n', '<leader>nc', '<Cmd>NNPCoding<CR>')
vim.keymap.set('n', '<leader>nn', '<Cmd>NNPNotes<CR>')
EOF
endif
