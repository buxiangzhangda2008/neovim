local M = {}

function M.setup()
  require("neotest").setup {
    adapters = {
      require "neotest-python" {
        dap = { justMyCode = false },
        runner = "unittest",
      },
      require "neotest-jest",
      require "neotest-go",
      require "neotest-plenary",
      require "neotest-vim-test" {
        ignore_file_types = { "python", "vim", "lua" },
      },
    },
    log_level = "debug",
    discovery = {
      enabled = false,
    },
    output = {
      enabled = true,
      open_on_run = true,
    },
    floating = {
      border = "rounded",
      max_height = 0.8,
      max_width = 0.8,
      options = {},
    },
    icons = {
      child_indent = "│",
      child_prefix = "├",
      collapsed = "─",
      expanded = "╮",
      failed = "✖",
      final_child_indent = " ",
      final_child_prefix = "╰",
      non_collapsible = "─",
      passed = "✔",
      running = "🗘",
      running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
      skipped = "ﰸ",
      unknown = "?"
    },
    -- icons = {
    --   child_indent = "│",
    --   child_prefix = "├",
    --   collapsed = "─",
    --   expanded = "╮",
    --   failed = "❌",
    --   final_child_indent = " ",
    --   final_child_prefix = "╰",
    --   non_collapsible = "─",
    --   passed = "✅",
    --   running = "🏃",
    --   running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    --   skipped = "🦐",
    --   unknown = "❔"
    -- },

  }
end

return M
