local M = {}
local gs = require "gitsigns"
local whichkey = require "which-key"
local keymap_leader = {
	h = {
		name = "hunk",
		s = { "<cmd>Gitsigns stage_hunk<CR>", "stage hunk" },
		S = { "<cmd>Gitsigns stage_buffer<CR>", "stage buffer" },
		u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "undo state hunk" },
		r = { "<cmd>Gitsigns reset_buffer<CR>", "reset buffer" },
		p = { "<cmd>Gitsigns preview_hunk<CR>", "preview hunk" },
		b = {
			function()
				gs.blame_line { full = true }
			end,
			"blame_line",
		},
		l = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "toggle_current_line_blame" },
		d = { "<cmd>Gitsigns diffthis<CR>", "diff this" },
		D = {
			function()
				gs.diffthis "~"
			end,
			"diff this",
		},
		m = { "<cmd>Gitsigns toggle_deleted<CR>", "toggle_deleted" },
		n = { "<cmd>Gitsigns next_hunk<CR>", "next_hunk" },
		N = { "<cmd>Gitsigns prev_hunk<CR>", "prev_hunk" },
	},
}
-- local keymap_leader2 = {
--   name = "select hunk",
--   i = {
--     h = { "<cmd>Gitsigns select_hunk<cr>", "select_hunk" },
--   },
-- }
function M.setup()
	gs.setup {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_", show_count = true },
			topdelete = { text = "‾", show_count = true },
			changedelete = { text = "~", show_count = true },
		},
		debug_mode = true,
		on_attach = function(bufnr)
			-- whichkey.register(
			--   keymap_leader2,
			--   { mode = "o", buffer = bufnr, prefix = "<leader>", noremap = true, silent = true }
			-- )
			whichkey.register(
				keymap_leader,
				{ mode = "n", buffer = bufnr, prefix = "<leader>", noremap = true, silent = true }
			)
			-- local function map(mode, l, r, opts)
			-- 	opts = opts or {}
			-- 	opts.buffer = bufnr
			-- 	vim.keymap.set(mode, l, r, opts)

			-- end

			-- Navigation
			-- map("n", "]c", function()
			-- 	if vim.wo.diff then
			-- 		return "]c"
			-- 	end
			-- 	vim.schedule(function()
			-- 		gs.next_hunk()
			-- 	end)
			-- 	return "<Ignore>"
			-- end, { expr = true })
			--
			-- map("n", "[c", function()
			-- 	if vim.wo.diff then
			-- 		return "[c"
			-- 	end
			-- 	vim.schedule(function()
			-- 		gs.prev_hunk()
			-- 	end)
			-- 	return "<Ignore>"
			-- end, { expr = true })
			--
			-- -- Actions
			-- map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
			-- map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
			-- map("n", "<leader>hS", gs.stage_buffer)
			-- map("n", "<leader>hu", gs.undo_stage_hunk)
			-- map("n", "<leader>hR", gs.reset_buffer)
			-- map("n", "<leader>hp", gs.preview_hunk)
			-- map("n", "<leader>hb", function()
			-- 	gs.blame_line { full = true }
			-- end)
			-- map("n", "<leader>tb", gs.toggle_current_line_blame)
			-- map("n", "<leader>hd", gs.diffthis)
			-- map("n", "<leader>hD", function()
			-- 	gs.diffthis "~"
			-- end)
			-- map("n", "<leader>td", gs.toggle_deleted)
			--
			-- -- Text object
			-- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	}
end

return M
