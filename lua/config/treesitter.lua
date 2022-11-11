local M = {}

local function setup_rainbow()
  -- fixup nvim-treesitter cause luochen1990/rainbow not working problem
  -- see https://github.com/nvim-treesitter/nvim-treesitter/issues/123#issuecomment-651162962
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/654#issuecomment-727562988
  -- https://github.com/luochen1990/rainbow/issues/151#issuecomment-677644891
  vim.g.rainbow_active = 1
  require "nvim-treesitter.highlight"
  -- vim.TSHighlighter is removed, please use vim.treesitter.highlighter
  -- see https://github.com/neovim/neovim/pull/14145/commits/b5401418768af496ef23b790f700a44b61ad784d
  -- deactivate highlight of TSPunctBracket
  -- local hlmap = vim.treesitter.highlighter.hl_map
  -- hlmap.error = nil
  -- hlmap["punctuation.delimiter"] = "Delimiter"
  -- hlmap["punctuation.bracket"] = nil
end

function M.setup()
  require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all"
    ensure_installed = { "java", "json", "vim", "c", "cpp", "lua", "python", "pioasm", "bash" },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- auto_install = true,
    ignore_install = { "phpdoc" },
    highlight = {
      -- `false` will disable the whole extension
      enable = false,
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },

    -- rainbow = {
    -- 	enable = true,
    -- 	-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    -- 	extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    -- 	max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- 	-- colors = {}, -- table of hex strings
    -- 	-- termcolors = {} -- table of colour name strings
    -- },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },

    indent = { enable = true },

    endwise = {
      enable = true,
    },
    -- nvim-treesitter-textobjects
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ["<leader>rx"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>rX"] = "@parameter.inner",
        },
      },

      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]]"] = "@function.inner",
          ["]m"] = "@class.outer",
        },
        goto_next_end = {
          ["]["] = "@function.inner",
          ["]M"] = "@class.outer",
        },
        goto_previous_start = {
          ["[["] = "@function.inner",
          ["[m"] = "@class.outer",
        },
        goto_previous_end = {
          ["[]"] = "@function.inner",
          ["[M"] = "@class.outer",
        },
      },

      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {
          ["<leader>df"] = "@function.outer",
          ["<leader>dF"] = "@class.outer",
        },
      },
    },
  }
  setup_rainbow()
end

return M
