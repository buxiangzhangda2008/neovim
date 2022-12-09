local M = {}
-- local cmp_nvim_lsp = require "cmp_nvim_lsp"
local servers = {
  gopls = {},
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
    -- capabilities = capabilities,
    -- capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  },

  pyright = {},
  rust_analyzer = {},
  sumneko_lua = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Both",
          workspaceWord = false,
          postfix = "@",
        },
        -- diagnostics = {
        --   -- Get the language server to recognize the `vim` global
        --   globals = { "vim" },
        -- },
        -- workspace = {
        --   checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
        -- },
      },
    },
  },
  tsserver = {},
  vimls = {},
  jdtls = {},
  awk_ls = {},
  lemminx = {},
  marksman = {},
  asm_lsp = {},
}

function M.on_attach(client, bufnr)
  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)
  -- Configure highlighting
  -- client.resolved_capabilities.document_highlight = false
  -- client.server_capabilities.documentHighlightProvider = false
  require("config.lsp.highlighting").setup(client)
  -- Configure formatting
  require("config.lsp.null-ls.formatters").setup(client, bufnr)
  -- Configure for Typescript
  if client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end
  -- Configure for jdtls
  if client.name == "jdt.ls" then
    require("jdtls").setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs()
    -- client.resolved_capabilities.document_highlight = false
    -- client.server_capabilities.documentHighlightProvider = false
    vim.lsp.codelens.refresh()
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
-- capabilities.document_highlight = false
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
if PLUGINS.nvim_cmp.enabled then
  M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
else
  M.capabilities = capabilities
end

local opts = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}
-- Setup LSP handlers
require("config.lsp.handlers").setup()

function M.setup()
  -- null-ls
  require("config.lsp.null-ls").setup(opts)

  -- installer
  require("config.lsp.installer").setup(servers, opts)
end

return M
