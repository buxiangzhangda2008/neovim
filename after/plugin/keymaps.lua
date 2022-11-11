local whichkey = require "which-key"
local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }
-- keymap("n", "<c-d>", "<c-y>", default_opts)
keymap("x", "<c-c>", '"+y', default_opts)
keymap("n", "<c-c>", 'v"+y', default_opts)
keymap("n", "<c-p>", '"+p', default_opts)
keymap("x", "<c-p>", '"+p', default_opts)
keymap("i", "<c-p>", '<Nop>', default_opts)
keymap("i", "<c-n>", '<Nop>', default_opts)

-- visual line wraps
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

keymap("v", "<", "<gv", default_opts)
keymap("v", ">", ">gv", default_opts)

-- paste over currently selected text without yanking it
keymap("v", "p", '"_dp', default_opts)
keymap("s", "\"", "\"")
keymap("s", "p", "p")
keymap("s", "m", "m")
-- add one line above in insert mode
keymap("i", "<c-o>", "<esc>ko")
-- delet current line in insert mode
keymap("i", "<c-d>", "<esc>ddA")
--keymap("i", "<c-[>", "<esc>d0I")
keymap("i", "<c-]>", "<esc>ld$A")

-- switch buffer
keymap("n", "<s-h>", ":bprevious<cr>", default_opts)
keymap("n", "<s-l>", ":bnext<cr>", default_opts)
-- cancel search highlighting with ESC
keymap("n", "<ESC>", ":nohlsearch<bar>:echo<cr>", default_opts)
keymap("n", "<F4>", "<cmd>TSToggle highlight<cr>", default_opts)
keymap("n", "<F10>", "<cmd>lua require('neotest').summary.toggle()<cr>", default_opts)
vim.keymap.set('n', '<f6>', require('undotree').toggle, { noremap = true, silent = true })

-- move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<cr>gv-gv", default_opts)
keymap("x", "J", ":move '>+1<cr>gv-gv", default_opts)

-- resizing panes
keymap("n", "<left>", ":vertical resize -1<cr>", default_opts)
keymap("n", "<right>", ":vertical resize +1<cr>", default_opts)
keymap("n", "<down>", ":resize -1<cr>", default_opts)
keymap("n", "<up>", ":resize +1<cr>", default_opts)
keymap("n", "<tab><tab>", "<cmd>TaboutToggle<cr>", default_opts)

keymap("n", "<a-e>", "<cmd>qall<cr>", default_opts)
-- show file full path
keymap("n", "<a-g>", "2<c-g>", default_opts)
-- reload file
local function quitTabOrPage()
  local buffers = vim.api.nvim_exec([[buffers]], true)
  local lines = 0
  for line in string.gmatch(buffers, "([^\n]*)\n?") do
    print(line)
    lines = lines + 1
  end
  print("lines is " .. lines)
  local buftype = vim.opt.buftype:get()
  if lines > 2 then
    if buftype == "nofile" then
      vim.cmd([[
       bp
    bd! #]])
    else
      vim.cmd([[
    write
    bp
    bd! #]])
    end
  else

    if buftype == "nofile" then
      vim.cmd([[
    quit
    ]] )
    else

      vim.cmd([[
    wq
    ]] )
    end
  end
end

keymap({ "n", "i" }, "<a-q>", quitTabOrPage, default_opts)
keymap({ "n", "i" }, "<a-q>", quitTabOrPage, default_opts)
keymap({ "n", "i" }, "<a-r>", "<cmd>write<cr><cmd>so %<cr>", default_opts)
keymap({ "n", "i" }, "<a-w>", "<cmd>write<cr>", default_opts)
keymap("n", "<F11>", "<cmd>Twilight<cr>", default_opts)

keymap("n", "<ESC>]{0}i", "<c-i>", default_opts)
vim.cmd [[
  nnoremap <silent><ESC>]{0}i <c-i>
	"swap adjacent lines
  nnoremap <silent><ESC>]{0}j <cmd>m +1<cr>
  nnoremap <silent><c-k> <cmd>m -2<cr>

" swap adjacent words <c-h> <c-l>
	" make use of regex to substitute adjacent words then back cursor to the mark positons which mark at the beginning;
  nnoremap <silent><ESC>]{0}h mx"_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`xb<cmd>nohlsearch<cr><cmd>delmarks x<cr>
  nnoremap  <silent><c-l> mx"_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>/\w\+\_W\+<CR>`xw<cmd>nohlsearch<cr><cmd>delmarks x<cr>

" quick motion between windows
  nnoremap <silent><tab>h <C-W>h
  nnoremap <silent><tab>j <C-W>j
  nnoremap <silent><tab>l <C-W>l
  nnoremap <silent><tab>k <C-W>k
  nnoremap <silent><tab>h <C-W>h
  nnoremap <silent><tab>j <C-W>j
  nnoremap <silent><tab>l <C-W>l
  nnoremap <silent><tab>k <C-W>k

  inoremap <silent><tab>j <C-W>j
  inoremap <silent><tab>l <C-W>l
  inoremap <silent><tab>k <C-W>k
  inoremap <silent><tab>j <C-W>j

  tnoremap <silent><tab>j <C-\><C-N><C-W>j
  tnoremap <silent><tab>l <C-\><C-N><C-W>l
  tnoremap <silent><tab>k <C-\><C-N><C-W>k
  tnoremap <silent><tab>j <C-\><C-N><C-W>j

  " nnoremap <leader>aw) <cmd>execute "normal \<Plug>YsurroundiW)"<cr>
  " nnoremap <leader>aw( <cmd>execute "normal \<Plug>YsurroundiW)"<cr>
  " nnoremap <leader>aw" <cmd>execute "normal \<Plug>YsurroundiW\""<cr>
  " nnoremap <leader>aw' <cmd>execute "normal \<Plug>YsurroundiW'"<cr>
  " nnoremap <leader>aw< <cmd>execute "normal \<Plug>YsurroundiW>"<cr>
  " nnoremap <leader>aw> <cmd>execute "normal \<Plug>YsurroundiW>"<cr>
  "
  " nnoremap <leader>w) <cmd>execute "normal \<Plug>Ysurroundiw)"<cr>
  " nnoremap <leader>w( <cmd>execute "normal \<Plug>Ysurroundiw)"<cr>
  " nnoremap <leader>w' <cmd>execute "normal \<Plug>Ysurroundiw'"<cr>
  " nnoremap <leader>w" <cmd>execute "normal \<Plug>Ysurroundiw\""<cr>
  " nnoremap <leader>w< <cmd>execute "normal \<Plug>Ysurroundiw>"<cr>
  " nnoremap <leader>w> <cmd>execute "normal \<Plug>Ysurroundiw>"<cr>
  "
  nnoremap <leader>ww viw<C-G>
  " inoremap <leader>ww <ESC>eviw<C-G>
  " inoremap <leader>ws <ESC>wviw<C-G>

  " snoremap <silent><ESC>]{0}j <esc>wviw<C-G>
  " snoremap <c-h> <esc>geviw<C-G>
  snoremap <c-e> <esc>a
 ]]
local function showWBrList()
  local brs = { "\"", "'", ")", "}", "]", ">" }
  vim.ui.select(brs, {
    prompt = "Select a bracket:",
    format_item = function(item)
      return "BRA - " .. item
    end,
  }, function(_, idx)
    if not idx then
      return
    end
    local br = "\\\""
    if brs[idx] ~= "\"" then
      br = brs[idx]
    end
    vim.api.nvim_exec("execute \"normal \\<Plug>YsurroundiW" .. br .. "\"", false)
  end)
end

local function showBrList()
  local brs = { "\"", "'", ")", "}", "]", ">" }
  vim.ui.select(brs, {
    prompt = "Select a bracket:",
    format_item = function(item)
      return "BRA - " .. item
    end,
  }, function(_, idx)
    if not idx then
      return
    end
    local br = "\\\""
    if brs[idx] ~= "\"" then
      br = brs[idx]
    end
    vim.api.nvim_exec("execute \"normal \\<Plug>Ysurroundiw" .. br .. "\"", false)
  end)
end

vim.keymap.set("n", "<leader>sw", showBrList, { silent = true })
vim.keymap.set("n", "<leader>sW", showWBrList, { silent = true })
vim.keymap.set("n", "<space>l", "<cmd>JABSOpen<cr>", { silent = true })

local escapeChars = { ",", "\"", "'", "(", ")", "}", "{", ":", ";", ".", "<", ">", "-", "`", "|", "[", "]", "=", "+", "_",
  "*",
  "&", "%" }
vim.keymap.set("i", "<leader>ww", function()
  vim.api.nvim_exec(
    [[ 
  let key = nvim_replace_termcodes("<esc>", v:true, v:false, v:true)
  call nvim_feedkeys(key, 'n', v:false) 
  ]] , false)

  while true do
    vim.api.nvim_exec([[ execute "normal \<esc>e" ]], false)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local char = string.sub(line, col + 1, col + 1)
    local escape = false
    for _, value in pairs(escapeChars) do
      if value == char then
        escape = true
        break
      end
    end
    if not escape then
      break
    end
  end
  vim.api.nvim_exec([[ execute "normal viwl\<C-G>" ]], false)

end, { silent = true })
vim.keymap.set("s", "<c-l>", function()
  while true do
    vim.api.nvim_exec([[ execute "normal \<esc>e" ]], false)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local char = string.sub(line, col + 1, col + 1)
    local escape = false
    for _, value in pairs(escapeChars) do
      if value == char then
        escape = true
        break
      end
    end
    if not escape then
      break
    end
  end
  vim.api.nvim_exec([[ execute "normal \<esc>viw\<C-G>" ]], false)

end, { silent = true })
vim.keymap.set("s", "<ESC>]{0}h", function()
  while true do
    vim.api.nvim_exec([[ execute "normal \<esc>ge" ]], false)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local char = string.sub(line, col + 1, col + 1)
    local escape = false
    for _, value in pairs(escapeChars) do
      if value == char then
        escape = true
        break
      end
    end
    if not escape then
      break
    end
  end
  vim.api.nvim_exec([[ execute "normal \<esc>viw\<C-G>" ]], false)

end, { silent = true })
vim.cmd [[
inoremap <c-k> <up>
inoremap <c-e> <c-o>$
inoremap <c-a> <c-o>^
inoremap <c-l> <right>
inoremap <silent><ESC>]{0}j <down>
inoremap <silent><ESC>]{0}h <left>
tnoremap <c-k> <up>
tnoremap <c-l> <right>
tnoremap {0}j <down>
tnoremap {0}h <left>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <ESC><ESC> <C-\><C-n>
cnoremap <ESC>]{0}h <left>
cnoremap <ESC>]{0}j <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>

" nnoremap <silent> <leader>fx :lua require('config.telescope').switch_projects()<CR>
" nnoremap <silent> <leader>fp :Telescope project<CR>
cnoremap <c-a> <home>

noremap <silent> <a-k> :call smooth_scroll#up(20, 0, 5)<CR>
noremap <silent> <a-j> :call smooth_scroll#down(20, 0, 5)<CR>
vnoremap = <Plug>(expand_region_expand)
vnoremap - <Plug>(expand_region_shrink)
]]
-- open term
vim.keymap.set("n", "<F3>", "<cmd>ToggleTerm -size=100<CR>", { silent = true, noremap = true })
vim.keymap.set("t", "<F3>", "<C-\\><C-n><cmd>ToggleTerm<CR>", { silent = true, noremap = true })

whichkey.register(
  { ["gg"] = { "<cmd>Neogen func<CR>", "gen func doc" } },
  { mode = "n", prefix = "<leader>", silent = true, noremap = true, nowait = false }
)
whichkey.register(
  { ["G"] = { "<cmd>Neogen class<CR>", "gen class doc" } },
  { mode = "n", prefix = "<leader>", silent = true, noremap = true, nowait = false }
)
whichkey.register(
  { ["m"] = { "<cmd>lua require(\"utils.treesitter\").goto_function()<cr>", "navigate methods" } },
  { mode = "n", prefix = "g", silent = true, noremap = true, nowait = false }
)
whichkey.register(
  { ["o"] = { "<cmd>SymbolsOutline<CR>", "symbol outline" } },
  { mode = "n", prefix = "<leader>", silent = true, noremap = true, nowait = false }
)

local keymaps_leader_b = {
  b = {
    name = "Build mvn project"
  }
}
local keymaps_comment_b = {
  b = {
    name = "Comment block"
  }
}
local keymaps_tab = {
  ["<tab>"] = {
    name = "tab",
    h = { name = "win left" },
    l = { name = "win right" },
    k = { name = "win up" },
    j = { name = "win down" },
  }
}
local keymaps_treesitter_r = {
  r = {
    name = "treesitter swap"
  }
}
local keymaps_persistence_p = {
  s = {
    name = "persistence",
    s = { "<cmd>lua require(\"persistence\").load()<cr>", "Persistence load" },
    l = { "<cmd>lua require(\"persistence\").load({last = true})<cr>", "Persistence load last" },
    t = { "<cmd>lua require(\"persistence\").stop()<cr>", "Persistence stop" },
  },
}

local leader_default_opts = { mode = "n", prefix = "<leader>", silent = true, noremap = true, nowait = false }
local g_default_opts = { mode = "n", prefix = "g", silent = true, noremap = true, nowait = false }
local tab_default_opts_n = { mode = "n", prefix = "", silent = true, noremap = true, nowait = false }
local tab_default_opts_c = { mode = "c", prefix = "", silent = true, noremap = true, nowait = false }
local tab_default_opts_i = { mode = "i", prefix = "", silent = true, noremap = true, nowait = false }
whichkey.register(keymaps_persistence_p, leader_default_opts)
whichkey.register(keymaps_treesitter_r, leader_default_opts)
whichkey.register(keymaps_leader_b, leader_default_opts)
whichkey.register(keymaps_comment_b, g_default_opts)
whichkey.register(keymaps_tab, tab_default_opts_i)
whichkey.register(keymaps_tab, tab_default_opts_n)
whichkey.register(keymaps_tab, tab_default_opts_c)
keymap("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
keymap("n", "<leader>fG", ":lua require('telescope').extensions.live_grep_args.live_grep_args({cwd=\"$HOME/.config/nvim-beginner/nvim/\",})<CR>")
  -- :lua require('telescope.builtin').live_grep({
  --   prompt_title = 'find string in open buffers...',
  --   grep_open_files = true
  -- })
keymap("n", "<leader>kk", ":lua require('utils.term').cht()<CR>")
keymap("n", "<leader>ks", ":lua require('utils.term').system_info_toggle()<CR>")
keymap("n", "<leader>kd", ":lua require('utils.term').lazy_docker()<CR>")
