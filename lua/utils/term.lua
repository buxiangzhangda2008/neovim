local M = {}
local Terminal = require("toggleterm.terminal").Terminal
-- Open a terminal
local function default_on_open(term)
  vim.cmd "stopinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

function M.open_term(cmd, opts)
  opts.size = opts.size or vim.o.columns * 0.5
  opts.direction = opts.direction or "vertical"
  opts.on_open = opts.on_open or default_on_open
  opts.on_exit = opts.on_exit or nil

  local new_term = Terminal:new {
    cmd = cmd,
    dir = "git_dir",
    auto_scroll = false,
    close_on_exit = false,
    start_in_insert = false,
    on_open = opts.on_open,
    on_exit = opts.on_exit,
  }
  new_term:open(opts.size, opts.direction)
end

-- Tokei
local tokei = "tokei"

local project_info = Terminal:new {
  cmd = tokei,
  dir = "git_dir",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
  close_on_exit = false,
}

function M.project_info_toggle()
  project_info:toggle()
end

local git_tui = "lazygit"
local docker_tui = "lazydocker"

local git_client = Terminal:new {
  cmd = git_tui,
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
}
local lazy_docker = Terminal:new {
  cmd = docker_tui,
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
}
-- Bottom
local bottom = "btm"
function M.git_client_toggle()
  git_client:toggle()
end

function M.lazy_docker()
  lazy_docker:toggle()
end

local system_info = Terminal:new {
  cmd = bottom,
  dir = "git_dir",
  hidden = true,
  direction = "float",
  float_opts = {
    border = "double",
  },
  close_on_exit = true,
}
local lang = ""
local function cht_on_open(term)
  vim.cmd "stopinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_name(term.bufnr, "cheatsheet-" .. term.bufnr)
  vim.api.nvim_buf_set_option(term.bufnr, "filetype", "cheat")
  vim.api.nvim_buf_set_option(term.bufnr, "syntax", lang)
end

function M.system_info_toggle()
  system_info:toggle()
end

local function cht_on_exit(term)
  vim.cmd [[normal gg]]
end

function M.cht()
  lang = ""
  vim.ui.input({ prompt = "cheatsheet (usage: [lang] query<CR>)" }, function(input)
    local cmd = ""
    if input == "" or not input then
      return
    elseif input == "h" then
      cmd = ""
    else
      local search = ""
      local delimiter = " "
      for w in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        if lang == "" then
          lang = w
        else
          if search == "" then
            search = w
          else
            search = search .. "+" .. w
          end
        end
      end
      cmd = lang
      if search ~= "" then
        cmd = cmd .. "/" .. search
      end
    end
    cmd = "curl cht.sh/" .. cmd
    M.open_term(cmd, { on_open = cht_on_open, on_exit = cht_on_exit })
  end)
end

return M
