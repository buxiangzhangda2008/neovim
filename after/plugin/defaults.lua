local api = vim.api
local g = vim.g
local opt = vim.opt


-- Remap leader and local leader to <Space>
api.nvim_set_keymap("", "\\", "<Nop>", { noremap = true, silent = true })

api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifuc")
g.mapleader = "\\"
g.maplocalleader = "\\"

-- g.rainbow_active = 1
opt.termguicolors = true -- Enable colors in terminal
opt.hlsearch = true --Set highlight on search
opt.number = true --Make line numbers default
opt.relativenumber = false --Make relative number default
opt.mouse = "a" --Enable mouse mode
opt.breakindent = true --Enable break indent
opt.undofile = true --Save undo history
opt.ignorecase = true --Case insensitive searching unless /C or capital in search
opt.smartcase = true -- Smart case
opt.updatetime = 250 --Decrease update time
opt.signcolumn = "yes" -- Always show sign column
--opt.clipboard = "unnamedplus" -- Access system clipboard
opt.laststatus = 3 -- Global status line
--opt.cmdheight = 0
-- Time in milliseconds to wait a mapped sequence to complete
opt.timeoutlen = 300
opt.path:remove "/usr/include"
opt.path:append "**"
opt.wildignorecase = true

-- Better search
opt.path:remove "/usr/include"
opt.path:append "**"
-- vim.cmd [[set path=.,,,$PWD/**]] -- Set the path directly

opt.wildignorecase = true
opt.wildignore:append "**/node_modules/*"
opt.wildignore:append "**/.git/*"

vim.wo.cursorline = true
vim.wo.colorcolumn = "160"
-- Better Netrw, alternatively just use vinegar.vim
-- g.netrw_banner = 0 -- Hide banner
-- g.netrw_browse_split = 4 -- Open in previous window
-- g.netrw_altv = 1 -- Open with right splitting
-- g.netrw_liststyle = 3 -- Tree-style view
-- g.netrw_list_hide = (vim.fn["netrw_gitignore#Hide"]()) .. [[,\(^\|\s\s\)\zs\.\S\+]] -- use .gitignore
-- vim.o.tabstop = 8
-- vim.bo.tabstop = 8
-- vim.o.softtabstop = 4
-- vim.o.shiftround = true
-- vim.o.shiftwidth = 4
-- vim.bo.shiftwidth = 4
-- Treesitter based folding
-- opt.foldlevel = 20
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = -1
opt.foldenable = true
vim.cmd [[
	" highlight CursorLine ctermfg=LightYellow guifg=Yellow guibg=#5c6370
	highlight CursorLine ctermfg=LightYellow guibg=#5c6370
  set fileencodings=utf-8,ucs-bom,gb18030,gb2312,cp936
  set termencoding=utf-8
  set encoding=utf-8
  set expandtab
	" highlight CurrentWord ctermfg=LightYellow guifg=LightMagenta guibg=Gray
	" highlight LspReferenceText ctermfg=LightYellow guifg=Red guibg=LightGrey
	" highlight LspReferenceRead ctermfg=LightYellow guifg=Red guibg=LightGrey
]]

vim.notify = require("notify")
