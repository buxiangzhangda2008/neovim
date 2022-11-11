local M = {}

function M.setup()
  require("substitute").setup()
  vim.keymap.set("n", "<space>t", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
  vim.keymap.set("n", "<space>tt", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
  vim.keymap.set("n", "<space>T", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
  vim.keymap.set("x", "<space>t", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
  vim.notify "Substitute setup"

  vim.keymap.set("n", "<space>x", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
  vim.keymap.set("n", "<space>xx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
  vim.keymap.set("x", "<space>X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
  vim.keymap.set("n", "<space>xc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
end

return M
