---@diagnostic disable: undefined_variable
local M = {}
local whichkey = require "which-key"
local conf = {
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = false, -- default bindings on <c-w>
      nav = false, -- misc bindings to work with windows
      z = false, -- bindings for folds, spelling and others prefixed with z
      g = false, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by deafult for Telescope
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
}
local function code_keymap()
  vim.cmd "autocmd FileType * lua CodeRunner()"

  function CodeRunner()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local fname = vim.fn.expand "%:p:t"
    local keymap_c = {} -- normal key map
    local keymap_c_v = {} -- visual key map

    if ft == "python" then
      keymap_c = {
        name = "Code",
        r = { "<cmd>update<CR><cmd>exec '!python3' shellescape(@%, 1)<cr>", "Run" },
        m = { "<cmd>TermExec cmd='nodemon -e py %'<cr>", "Monitor" },
      }
    elseif ft == "lua" then
      keymap_c = {
        name = "Code",
        r = { "<cmd>luafile %<cr>", "Run" },
      }
    elseif ft == "go" then
      keymap_c = {
        name = "Code",
        r = { "<cmd>GoRun<cr>", "Run" },
      }
    elseif ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
      keymap_c = {
        name = "Code",
        o = { "<cmd>TypescriptOrganizeImports<cr>", "Organize Imports" },
        r = { "<cmd>TypescriptRenameFile<cr>", "Rename File" },
        i = { "<cmd>TypescriptAddMissingImports<cr>", "Import Missing" },
        F = { "<cmd>TypescriptFixAll<cr>", "Fix All" },
        u = { "<cmd>TypescriptRemoveUnused<cr>", "Remove Unused" },
        R = { "<cmd>lua require('config.test').javascript_runner()<cr>", "Choose Test Runner" },
        s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" },
        t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" },
      }
    elseif ft == "java" then
      keymap_c = {
        name = "Code",
        o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
        v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
        c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
        t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
        n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
      }
      keymap_c_v = {
        name = "Code",
        v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
        c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
        m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
      }
    end

    if fname == "package.json" then
      keymap_c.v = { "<cmd>lua require('package-info').show()<cr>", "Show Version" }
      keymap_c.c = { "<cmd>lua require('package-info').change_version()<cr>", "Change Version" }
      keymap_c.s = { "<cmd>2TermExec cmd='yarn start'<cr>", "Yarn Start" }
      keymap_c.t = { "<cmd>2TermExec cmd='yarn test'<cr>", "Yarn Test" }
    end

    if fname == "Cargo.toml" then
      keymap_c.u = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade All Crates" }
    end

    if next(keymap_c) ~= nil then
      whichkey.register(
        { c = keymap_c },
        { mode = "n", silent = true, noremap = true, buffer = bufnr, prefix = "<space>", nowait = true }
      )
    end

    if next(keymap_c_v) ~= nil then
      whichkey.register(
        { c = keymap_c_v },
        { mode = "v", silent = true, noremap = true, buffer = bufnr, prefix = "<space>", nowait = true }
      )
    end
  end
end

local function normal_keymap()
  whichkey.setup(conf)
  local mappings = {

    z = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      C = { "<cmd>PackerClean<cr>", "Clean" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    g = {
      name = "Git | Generator",
      -- s = { "<cmd>Neogit<CR>", "Status" },
      u = { "<cmd>lua require('utils.term').git_client_toggle()<CR>", "Git TUI" },
    },
    -- Database
    D = {
      name = "Database",
      u = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
      f = { "<Cmd>DBUIFindBuffer<Cr>", "Find buffer" },
      r = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
      q = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
    },
  }
  local default_opts = { mode = "n", prefix = "<leader>", silent = true, noremap = true, nowait = false }
  whichkey.register(mappings, default_opts)
  whichkey.register(
    { ["<F1>"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" } },
    { mode = "n", prefix = "", silent = true, noremap = true, nowait = false }
  )
  whichkey.register(
    { ["<F2>"] = { "<cmd>NvimTreeFindFile<cr>", "Find file in Tree" } },
    { mode = "n", prefix = "", silent = true, noremap = true, nowait = false }
  )
  -- whichkey.register(
  --   { ["<F2>"] = { "<cmd>edit!<cr>", "Reload Document" } },
  --   { mode = "n", prefix = "", silent = true, noremap = true, nowait = false }
  -- )
  whichkey.register(
    { ["al"] = { "<cmd>TextCaseOpenTelescope<cr>", "case list" } },
    { mode = "v", prefix = "g", silent = true, noremap = true, nowait = false }
  )
  whichkey.register(
    { ["al"] = { "<cmd>TextCaseOpenTelescope<cr>", "case list" } },
    { mode = "n", prefix = "g", silent = true, noremap = true, nowait = false }
  )
  whichkey.register(
    { ["l"] = { "<cmd>HopLine<cr>", "navigate by line" } },
    { mode = "n", prefix = "g", silent = true, noremap = true, nowait = false }
  )

  whichkey.register(
    { ["w"] = { "<cmd>HopWord<cr>", "navigate by word" } },
    { mode = "n", prefix = "g", silent = true, noremap = true, nowait = false }
  )
  if PLUGINS.telescope.enabled then
    local keymaps_f = {
      f = {
        name = "Telescope Find",
        -- f = { "<cmd>lua require('utils.finder').find_files()<cr>", "Files" },
        d = { "<cmd>lua require('utils.finder').find_dotfiles()<cr>", "Dotfiles" },
        l = { "<cmd>Telescope repo list<cr>", "List Repos" },
        f = { "<cmd>Telescope find_files<cr>", "Files" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
        e = { "<cmd>Telescope git_files<cr>", "Git Files" },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        r = { "<cmd>Telescope file_browser<cr>", "Browser" },
        w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
        n = { "<cmd>Telescope notify<cr>", "List Notify" },
        t = { "<cmd>TodoTelescope keywords=TODO,Todo,todo<cr>", "List Todo" },
        p = { "<cmd>Telescope neoclip<cr>", "Clipboard" },
        w = { "<cmd>Telescope bookmarks<cr>", "Browser bookmarks" },
        m = { "<cmd>MarksListAll<cr>", "Marks" },
        --e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
      },
      x = {
        name = "External",
        p = { "<cmd>lua require('utils.term').project_info_toggle()<CR>", "Project Code statistics" },
      },
    }

    local keymaps_p = {
      p = {
        name = "Project",
        p = { "<cmd>lua require'telescope'.extensions.project.project{}<cr>", "List" },
        s = { "<cmd>Telescope repo list<cr>", "Search" },
      },
    }
    local keymaps_doc_c = {

      c = {
        name = "Code",
        g = { "<cmd>Neogen func<Cr>", "Func Doc" },
        G = { "<cmd>Neogen class<Cr>", "Class Doc" },
      },
    }
    local keymaps_test_t = {
      -- t = {
      --   name = "Test",
      --   S = { "<cmd>UltestSummary<cr>", "Summary" },
      --   a = { "<cmd>Ultest<cr>", "All" },
      --   d = { "<cmd>UltestDebug<cr>", "Debug" },
      --   f = { "<cmd>TestFile<cr>", "File" },
      --   l = { "<cmd>TestLast<cr>", "Last" },
      --   n = { "<cmd>TestNearest<cr>", "Nearest" },
      --   o = { "<cmd>UltestOutput<cr>", "Output" },
      --   s = { "<cmd>TestSuite<cr>", "Suite" },
      --   v = { "<cmd>TestVisit<cr>", "Visit" },
      -- },
      n = {
        name = "Neotest",
        a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
        f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
        F = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Debug File" },
        l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
        L = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
        n = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
        N = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
        o = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Output" },
        S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
        s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
      },
    }
    whichkey.register(keymaps_f, default_opts)
    whichkey.register(keymaps_p, default_opts)
    whichkey.register(keymaps_test_t, default_opts)
    whichkey.register(keymaps_doc_c, default_opts)
  end
end

function M.setup()
  normal_keymap()
  -- visual_keymap()
  code_keymap()
end

return M
