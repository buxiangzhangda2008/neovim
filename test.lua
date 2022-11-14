local M = {}

function M.setup()

end

local str = "- firstBlood second-blood thirdBlood"
-- print(string.gsub(str, "[a-zA-Z0-9_\\-]+", "word"))
local col = vim.api.nvim_win_get_cursor(0)[2]
print(string.find(str, "[a-zA-Z0-9_]+", col))
print(string.find(str, "[a-zA-Z0-9_]+", col))
return M
