local M = {}

function M.setup()
  require("formatter").setup {
    filetype = {
      java = {
        function()
          return {
            exe = "java",
            args = { "-jar", os.getenv "HOME" .. "/.local/jars/google-java-format.jar", vim.api.nvim_buf_get_name(0) },
            stdin = true,
          }
        end,
      },
    },
  }

  -- vim.api.nvim_exec(
  --   [[
  --       augroup FormatAutogroup
  --         autocmd!
  --         autocmd BufWritePost *.java FormatWrite
  --       augroup end
  --     ]],
  --   true
  -- )
end

return M
