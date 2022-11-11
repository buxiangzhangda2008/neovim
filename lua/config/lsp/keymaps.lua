local M = {}

local whichkey = require "which-key"

-- local keymap = vim.api.nvim_set_keymap
-- local buf_keymap = vim.api.nvim_buf_set_keymap

local function keymappings(client, bufnr)
  -- vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

  -- local action = require "lspsaga.action"
  -- -- scroll down hover doc or scroll in definition preview
  -- vim.keymap.set("n", "<C-f>", function()
  -- 	action.smart_scroll_with_saga(1)
  -- end, { silent = true })
  -- -- scroll up hover doc
  -- vim.keymap.set("n", "<C-b>", function()
  -- 	action.smart_scroll_with_saga(-1)
  -- end, { silent = true })
  -- vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, noremap = true })
  -- vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, noremap = true })
  -- vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, noremap = true })
  -- vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, noremap = true })
  -- vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, noremap = true })
  -- -- jump diagnostic
  -- vim.keymap.set("n", "[d", require("lspsaga.diagnostic").goto_prev, { silent = true, noremap = true })
  -- vim.keymap.set("n", "]d", require("lspsaga.diagnostic").goto_next, { silent = true, noremap = true })
  -- -- or jump to error
  -- vim.keymap.set("n", "[e", function()
  --   require("lspsaga.diagnostic").goto_prev { severity = vim.diagnostic.severity.ERROR }
  -- end, { silent = true, noremap = true })
  -- vim.keymap.set("n", "]e", function()
  --   require("lspsaga.diagnostic").goto_next { severity = vim.diagnostic.severity.ERROR }
  -- end, { silent = true, noremap = true })
  -- vim.keymap.set("n", "S", "<Cmd>Lspsaga signature_help<CR>", { silent = true,noremap = true })

  -- Key mappings
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, noremap = true })
  -- s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },

  -- Whichkey
  local keymap_leader = {
    f = {},
  }
  local keymap_brackets = {
    name = "Diagnostics",
    q = { "<cmd>TroubleToggle quickfix<cr>", "Trouble quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "Trouble loclist" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble Document diagnostics" },
    t = { "<cmd>TroubleToggle<CR>", "Trouble toggle" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble workspace diagnostics" },
  }
  local keymap_space = {
    name = "Code",
    d = { "<cmd>Lspsaga lsp_finder<CR>", "references and definition" },
    r = { "<cmd>Lspsaga rename<CR>", "Rename" },
    -- f = { "<cmd>lua vim.lsp.buf.formatting({timeout=10000})<CR>", "Format Document" },
    f = { "<cmd>lua vim.lsp.buf.format({sync = true,timeout=10000})<CR>", "Format Document" },
    a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
    i = { "<cmd>Telescope lsp_incoming_calls<CR>", "Incomming Calls" },
    o = { "<cmd>Telescope lsp_outgoing_calls<CR>", "Outgoing Calls" },
    D = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
  }

  local keymap_v_space = {
    name = "Code",
    -- f = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format Document" },
    f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format Document" },
    a = { "<cmd>lua vim.lsp.buf.range_code_action()<CR>", "Code Action" },
  }

  local keymap_goto = {
    name = "Goto",
    g = {
      -- r = { "<cmd>Telescope lsp_references<CR>", "References" },
      r = { "<cmd>Telescope lsp_references<CR>", "References" },
      d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
      -- p = { "<Cmd>Lspsaga preview_definition<CR>", "Definition" },
      D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
    },
    -- ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "prev diagnostic" },
    -- ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "next diagnostic" },
    -- ["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", "prev error" },
    -- ["]e"] = { "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", "next error" },
  }
  whichkey.register(keymap_space, { mode = "n", buffer = bufnr, prefix = "<space>", noremap = true, silent = true })
  whichkey.register(keymap_v_space, { mode = "v", buffer = bufnr, prefix = "<space>", noremap = true, silent = true })
  whichkey.register(keymap_brackets, { mode = "n", prefix = "]", noremap = true, silent = true })
  whichkey.register(keymap_leader, { mode = "n", prefix = "<leader>", noremap = true, silent = true })
  whichkey.register(keymap_goto, { mode = "n", buffer = bufnr, prefix = "", noremap = true, silent = true })
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M
