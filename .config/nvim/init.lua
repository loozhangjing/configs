-- disable netrw (neovim's default file explorer)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- set <space> as the leader key (see `:h mapleader`)
-- NOTE: must happen before plugins are loaded (otherwise the wrong leader will be used)
vim.g.mapleader = ' '

-- OPTIONS
-- to see documentation for an option, use `:h 'optionname'`, for example `:h 'number'` (note the single quotes)

vim.o.number = true 		-- show line numbers in a column.
vim.o.relativenumber = true -- show line numbers relative to where the cursor is (affects the 'number' option above)

vim.opt.tabstop = 4			--- width of a tab character
vim.opt.shiftwidth = 4		--- width of an indent

-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true 	-- highlight the line where the cursor is on
vim.o.scrolloff = 0			-- keep this many screen lines above/below the cursor
vim.o.list = true			-- make characters defined in `vim.opt.listchars` visible
vim.opt.listchars = {		-- show invisible characters
	tab = '| ',
	trail = '·',			-- trailing whitespace
}

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) (see `:h 'confirm'`)
vim.o.confirm = true

-- KEYMAPS (see `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`)

-- map Alt + J, Alt + K, Alt + H, Alt + L to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- add newlines without going into insert mode with Enter and Shift + Enter
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<S-CR>', 'O<Esc>')

-- map coc's rename action to Alt + R
vim.keymap.set('n', '<A-r>', ':call CocActionAsync(\'rename\')<Enter>')

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- Quickstart configs for LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  -- Kanagawa colour scheme
  'https://github.com/rebelot/kanagawa.nvim',
  -- filetypes
  'https://github.com/evanleck/vim-svelte',
  'https://github.com/pangloss/vim-javascript',
  'https://github.com/othree/html5.vim',
  -- Intellisense
  'https://github.com/neoclide/coc.nvim',
  -- file explorer
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",

  "https://github.com/wakatime/vim-wakatime",
})

require('mini.completion').setup {}
require('quicker').setup {}
require('gitsigns').setup {}

vim.cmd('colorscheme kanagawa')

-- setup nvim-tree
require("nvim-tree").setup()
-- custom keybinds for nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>') -- open file explorer & focus on current file with space + e
