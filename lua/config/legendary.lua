local M = {}

local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

function M.setup()
  require("legendary").setup { include_builtin = true, auto_register_which_key = true }
  keymap("n", "<leader>l", "<cmd>lua require('legendary').find()<CR>", default_opts)
end

return M
