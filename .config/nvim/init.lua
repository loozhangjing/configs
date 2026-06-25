-- disable netrw (neovim's default file explorer), because nvim-tree (the file explorer in use) recommends it
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
vim.o.scrolloff = 6			-- keep this many screen lines above/below the cursor

vim.o.list = true			-- make characters defined in `vim.opt.listchars` visible
vim.opt.listchars = {		-- show invisible characters
	tab = '| ',				-- tabs are shown as a '|   ' (the space is repeated for the length of the tab)
	trail = '·',			-- trailing whitespace is shown as a '·'
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

-- in normal mode, add a newline above the current line with Enter or below the current line with Shift + Enter
vim.keymap.set('n', '<CR>', 'o<Esc>')
vim.keymap.set('n', '<S-CR>', 'O<Esc>')

-- map coc's rename action to Alt + R
vim.keymap.set('n', '<A-r>', ':call CocActionAsync(\'rename\')<Enter>')

-- open the file explorer & focus on the current file with Space + E
vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>') 

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

-- install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- quickstart configs for the nvim LSP client
  'https://github.com/neovim/nvim-lspconfig',
  -- tree-sitter (builds syntax trees from source code), used here for better Python syntax highlighting
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- autocomplete
  'https://github.com/nvim-mini/mini.completion',
  -- improved UI & workflow for the nvim quickfix
  'https://github.com/stevearc/quicker.nvim',
  -- git integration for buffers
  'https://github.com/lewis6991/gitsigns.nvim',

  -- syntax highlighting, indentation, autocomplete etc. for different languages
  'https://github.com/evanleck/vim-svelte',
  'https://github.com/pangloss/vim-javascript',
  'https://github.com/othree/html5.vim',

  -- Intellisense
  'https://github.com/neoclide/coc.nvim',

  -- file explorer
  "https://github.com/nvim-tree/nvim-tree.lua",
  -- Nerd Font icons (glyphs) for nvim plugins
  "https://github.com/nvim-tree/nvim-web-devicons",

  -- Kanagawa colour scheme
  'https://github.com/rebelot/kanagawa.nvim',

  -- analytics & time tracking
  "https://github.com/wakatime/vim-wakatime",
})

vim.diagnostic.config({
	-- show errors/warnings below the offending line when the cursor is on that line
	virtual_lines = {
		current_line = true,
	}
})

-- static type checker for Python
vim.lsp.enable('pyright') -- installation: npm install -g pyright
vim.lsp.enable('ruff') -- installation: pipx install ruff

-- treesitter syntax highlighting for Python
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function() vim.treesitter.start() end,
})

-- setup plugins
require('mini.completion').setup()
require('quicker').setup()
require('gitsigns').setup()

require("nvim-tree").setup({
	-- show errors/warnings in the file explorer
	diagnostics = {
		enable = true,
	}
})

vim.cmd('colorscheme kanagawa')
