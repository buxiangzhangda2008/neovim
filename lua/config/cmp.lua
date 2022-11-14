local M = {}

vim.o.completeopt = "menu,menuone,noselect"

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

function M.setup()
---@diagnostic disable-next-line: unused-function, unused_variable
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  local luasnip = require "luasnip"
  local cmp = require "cmp"
  local neogen = require "neogen"
  local c_k_func = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end
  local c_cp_func = function(fallback)
    if luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
---@diagnostic disable-next-line: param-type-mismatch
    elseif neogen.jumpable(true) then
      neogen.jump_prev()
    else
      fallback()
    end
  end
  local c_cn_func = function(fallback)
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif neogen.jumpable() then
      neogen.jump_next()
      -- elseif has_words_before() then
      --   cmp.complete()
    else
      fallback()
    end
  end
  local c_j_func = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end

  cmp.setup {
    completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
    experimental = { native_menu = false, ghost_text = false },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    formatting = {
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        -- Source
        vim_item.menu = ({
          luasnip = "[Snip]",
          nvim_lsp = "[LSP]",
          buffer = "[Buffer]",
          nvim_lua = "[Lua]",
          treesitter = "[Treesitter]",
          path = "[Path]",
          nvim_lsp_signature_help = "[Signature]",
        })[entry.source.name]
        return vim_item
      end,
    },

    mapping = {
      ["<C-o>"] = cmp.mapping(
        function(fallback)
          if luasnip.choice_active() and luasnip.in_snippet() then
            luasnip.change_choice(-1)
          else
            fallback()
          end
        end, { "i", "s", }
      ),
      ["<ESC>]{0}i"] = cmp.mapping(
        function(fallback)
          if luasnip.choice_active() and luasnip.in_snippet() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end, { "i", "s", }
      ),
      ["<c-l>"] = cmp.mapping {
        -- ["<ESC>]{0}h"] = cmp.mapping (
        i = function(fallback)
          if cmp.visible() then
            cmp.close()
          elseif luasnip.choice_active() and luasnip.in_snippet() then
            require "luasnip.extras.select_choice" ()
          else
            fallback()
          end
        end,
        s = function(fallback)
          if cmp.visible() then
            cmp.close()
          elseif luasnip.choice_active() and luasnip.in_snippet() then
            require "luasnip.extras.select_choice" ()
          else
            fallback()
          end
        end,
        c = function(fallback)
          if cmp.visible() then
            cmp.close()
          else
            fallback()
          end
        end,
      },
      -- ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i","n", "c" }),
      -- ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i","n", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      -- ["<c-l>"] = cmp.mapping { i = cmp.mapping.close(), c = cmp.mapping.close() },
      ["<CR>"] = cmp.mapping {
        i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
          else
            fallback()
          end
        end,
      },

      -- ["<c-2>"] = cmp.mapping(function(fallback)
      ["<c-n>"] = cmp.mapping {
        s = c_cn_func,
        i = c_cn_func,
        -- c = c_cn_func,
      },
      ["<ESC>]{0}j"] = cmp.mapping {
        -- ["<c-n>"] = cmp.mapping {
        s = c_j_func,
        i = c_j_func,
        c = c_j_func,
      },
      ["<c-p>"] = cmp.mapping {
        s = c_cp_func,
        i = c_cp_func,
      },
      ["<c-k>"] = cmp.mapping {
        -- ["<c-p>"] = cmp.mapping {
        s = c_k_func,
        i = c_k_func,
        c = c_k_func,
      },
    },
    sources = {
      { name = "luasnip" },
      { name = "nvim_lsp" },
      -- { name = "treesitter" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "nvim_lsp_signature_help" },
      -- { name = "spell" },
      -- { name = "emoji" },
      -- { name = "calc" },
    },
    window = {

      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
      },
    },
  }

  -- Use buffer source for `/`
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':'
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),

  })
  -- Auto pairs
  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
end

return M
