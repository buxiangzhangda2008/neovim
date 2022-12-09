local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
      enable = true,
      threshold = 0,
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    -- Colorscheme
    use {
      "sainnhe/everforest",
      config = function()
        vim.cmd "colorscheme everforest"
      end,
    }

    -- Startup screen
    use {
      "goolord/alpha-nvim",
      config = function()
        require("config.alpha").setup()
      end,
    }

    -- -- Git
    -- use {
    --   "TimUntersberger/neogit",
    --   cmd = "Neogit",
    --   requires = "nvim-lua/plenary.nvim",
    --   config = function()
    --     require("config.neogit").setup()
    --   end,
    -- }
    -- WhichKey
    use {
      "folke/which-key.nvim",
      -- event = "VimEnter",
      config = function()
        require("config.whichkey").setup()
      end,
    }
    -- IndentLine
    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.indentblankline").setup()
      end,
    }
    -- Load only when require
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Better icons
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- Better Comment
    use {
      "numToStr/Comment.nvim",
      opt = true,
      keys = { "gc", "gbc" },
      config = function()
        require("Comment").setup {}
      end,
    }

    -- Easy hopping
    use {
      "phaazon/hop.nvim",
      cmd = { "HopWord", "HopChar1", "HopLine" },
      config = function()
        require("hop").setup {}
      end,
    }

    -- -- Easy motion
    -- use {
    --   "ggandor/lightspeed.nvim",
    --   keys = { "s", "S", "f", "F", "t", "T" },
    --   config = function()
    --     require("lightspeed").setup {}
    --   end,
    -- }

    use {
      "ggandor/leap.nvim",
      config = function()
        require('leap').add_default_mappings()
      end
    }
    use {
      "ggandor/flit.nvim",
      config = function()
        require('flit').setup {
          keys = { f = 'f', F = 'F', t = 't', T = 'T' },
          -- A string like "nv", "nvo", "o", etc.
          labeled_modes = "v",
          multiline = true,
          -- Like `leap`s similar argument (call-specific overrides).
          -- E.g.: opts = { equivalence_classes = {} }
          opts = {}
        }
      end
    }

    -- Markdown
    use {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
      ft = "markdown",
      cmd = { "MarkdownPreview" },
    }
    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = function()
        require("config.lualine").setup()
      end,
      requires = { "nvim-web-devicons" },
    }
    use {
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter",
      module = "nvim-gps",
      config = function()
        require("nvim-gps").setup()
      end,
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
      },
    }
    use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      cmd = { "NvimTreeToggle", "NvimTreeClose", "NvimTreeFindFile" },
      config = function()
        require("config.nvimtree").setup()
      end,
    }
    -- Buffer line
    use {
      "akinsho/nvim-bufferline.lua",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      config = function()
        require("config.bufferline").setup()
      end,
    }
    -- Completion
    use {
      "hrsh7th/cmp-nvim-lsp",
    }
    use {
      "L3MON4D3/LuaSnip",
      wants = { "friendly-snippets", "vim-snippets" },
      config = function()
        require("config.snip").setup()
      end,
      requires = {
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
      }
    }
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        -- {
        --   "L3MON4D3/LuaSnip",
        --   wants = { "friendly-snippets", "vim-snippets" },
        --   config = function()
        --     require("config.snip").setup()
        --   end,
        -- },
      },
      disable = false,
    }

    -- Auto pairs
    use {
      "windwp/nvim-autopairs",
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    }
    -- Auto tag
    use {
      "windwp/nvim-ts-autotag",
      wants = "nvim-treesitter",
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
    }

    -- End wise
    use {
      "RRethy/nvim-treesitter-endwise",
      wants = "nvim-treesitter",
      event = "InsertEnter",
    }
    -- null-ls
    use {
      "jose-elias-alvarez/null-ls.nvim",
    }
    use {
      "b0o/schemastore.nvim",
    }
    -- LSP
    use {
      "neovim/nvim-lspconfig",
      -- opt = true,
      -- event = "BufReadPre",
      wants = {
        "nvim-lsp-installer",
        "cmp-nvim-lsp",
        "neodev.nvim",
        "vim-illuminate",
        "null-ls.nvim",
        "schemastore.nvim",
        "nvim-lsp-ts-utils",
      },
      config = function()
        require("config.lsp").setup()
      end,
      requires = {
        "williamboman/nvim-lsp-installer",
        "folke/neodev.nvim",
        "RRethy/vim-illuminate",
        "jose-elias-alvarez/null-ls.nvim",
        {
          "j-hui/fidget.nvim",
          config = function()
            require("fidget").setup {}
          end,
        },
        "b0o/schemastore.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils",
      },
    }

    use {
      "nvim-telescope/telescope.nvim",
      -- opt = true,
      config = function()
        require("config.telescope").setup()
      end,
      -- cmd = { "Telescope" },
      module = "telescope",
      -- keys = { "<leader>f", "<leader>p" },
      wants = {
        "plenary.nvim",
        "popup.nvim",
        "telescope-fzf-native.nvim",
        "telescope-project.nvim",
        "telescope-repo.nvim",
        "telescope-file-browser.nvim",
        -- "telescope-media-files.nvim",
        "project.nvim",
      },
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-project.nvim",
        "cljoly/telescope-repo.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        {
          "ahmedkhalf/project.nvim",
          config = function()
            require("project_nvim").setup {}
          end,
        },
        "nvim-telescope/telescope-media-files.nvim"
      },
    }
    -- trouble.nvim
    use {
      "folke/trouble.nvim",
      event = "BufReadPre",
      wants = "nvim-web-devicons",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup {
          use_diagnostic_signs = true,
        }
      end,
    }

    -- lspsaga.nvim
    use {
      "glepnir/lspsaga.nvim",
      event = "VimEnter",
      cmd = { "Lspsaga" },
      config = function()
        require("config.lspsaga").setup()
      end,
    }
    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("config.gitsigns").setup()
      end,
    }
    -- Go
    use {
      "ray-x/go.nvim",
      ft = { "go" },
      config = function()
        require("go").setup()
      end,
    }
    use {
      "rcarriga/nvim-dap-ui",
      requires = { "mfussenegger/nvim-dap" },
      config = function()
        require("config.dapui").setup()
      end
    }
    -- Debugging
    use {
      "mfussenegger/nvim-dap",
      opt = true,
      event = "BufReadPre",
      module = { "dap" },
      wants = {
        "nvim-dap-virtual-text",
        "DAPInstall.nvim",
        "nvim-dap-ui",
        "nvim-dap-python",
        "which-key.nvim",
        "dap-install",
      },
      requires = {
        "Pocco81/DAPInstall.nvim",
        "pedrohms/dap-install",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        { "leoluz/nvim-dap-go", module = "dap-go" },
        { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      },
      config = function()
        require("config.dap").setup()
      end,
    }
    use {
      "rcarriga/vim-ultest",
      requires = { "vim-test/vim-test" },
      opt = true,
      -- keys = { "<leader>t" },
      cmd = {
        "TestNearest",
        "TestFile",
        "TestSuite",
        "TestLast",
        "TestVisit",
        "Ultest",
        "UltestNearest",
        "UltestDebug",
        "UltestLast",
        "UltestSummary",
      },
      module = "ultest",
      run = ":UpdateRemotePlugins",
      config = function()
        require("config.test").setup()
      end,
    }
    use { "vim-test/vim-test" }
    use {
      "nvim-neotest/neotest",
      opt = true,
      wants = {
        "plenary.nvim",
        "nvim-treesitter",
        "FixCursorHold.nvim",
        "neotest-python",
        "neotest-plenary",
        "neotest-go",
        "neotest-jest",
        "neotest-vim-test",
      },
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-plenary",
        "nvim-neotest/neotest-go",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-vim-test",
      },
      module = { "neotest" },
      config = function()
        require("config.neotest").setup()
      end,
    }
    use {
      "norcalli/nvim-colorizer.lua",
      cmd = "ColorizerToggle",
      config = function()
        require("colorizer").setup()
      end,
    }
    use { "vim-ctrlspace/vim-ctrlspace" }
    -- Project
    use { "nvim-telescope/telescope-project.nvim" }
    --  use {
    --    "rmagatti/auto-session",
    --    config = function()
    --      require("auto-session").setup {
    --        log_level = "info",
    --        auto_session_suppress_dirs = { "~/", "~/Projects" },
    --      }
    --    end,
    -- disable = true,
    --  }
    -- Lua
    use {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      module = "persistence",
      config = function()
        require("persistence").setup()
      end,
    }
    -- use {
    --   "p00f/nvim-ts-rainbow",
    -- }
    use {
      "luochen1990/rainbow",
    }
    use { "nvim-treesitter/playground" }
    use {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      module = "neogen",
      disable = false,
    }
    use { "mfussenegger/nvim-jdtls", ft = { "java" } }
    use {
      "stevearc/dressing.nvim",
      event = "BufReadPre",
      config = function()
        require("dressing").setup {
          input = { relative = "editor" },
          select = {
            backend = { "telescope", "fzf", "builtin" },
          },
        }
      end,
      disable = false,
    }
    use {
      "weilbith/nvim-code-action-menu",
      cmd = "CodeActionMenu",
    }
    use {
      "kosayoda/nvim-lightbulb",
      requires = "antoinemadec/FixCursorHold.nvim",
    }
    use {
      "gerazov/vim-toggle-bool",
    }
    use {
      "AndrewRadev/switch.vim",
    }
    -- Lua
    use {
      "folke/twilight.nvim",
      config = function()
        require("twilight").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end,
    }
    use {
      "romgrk/nvim-treesitter-context",
      config = function()
        -- require("treesitter-context.config").setup { enable = true }
        require("treesitter-context").setup { enable = true }
      end,
    }
    use {
      "simrat39/symbols-outline.nvim",
      config = function()
        require("symbols-outline").setup { auto_preview = false }
      end,
    }
    use {
      "mhartington/formatter.nvim",
      config = function()
        require("config.formatter").setup()
      end,
    }
    use {
      "johmsalas/text-case.nvim",
      config = function()
        require("textcase").setup {
          prefix = 'ga',
        }
        require("telescope").load_extension "textcase"
      end,
    }
    use {
      "akinsho/toggleterm.nvim",
      tag = "*",
      config = function()
        require("toggleterm").setup()
      end,
    }
    use {
      "kevinhwang91/nvim-ufo",
      opt = true,
      event = { "BufRead" },
      wants = { "promise-async" },
      requires = "kevinhwang91/promise-async",
      config = function()
        require("ufo").setup {
          provider_selector = function()
            return { "lsp", "indent" }
          end,
        }
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      end,
    }
    use {
      "jiaoshijie/undotree",
      config = function()
        require('undotree').setup()
      end,
      requires = {
        "nvim-lua/plenary.nvim",
      },
    }
    use { "mikelue/vim-maven-plugin" }
    use { "tpope/vim-fugitive" }
    -- Database
    use {
      "tpope/vim-dadbod",
      opt = true,
      requires = {
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
      },
      config = function()
        require("config.dadbod").setup()
      end,
      cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
    }
    use { "diepm/vim-rest-console" }
    -- use { "dbeniamine/cheat.sh-vim" }
    use { "tpope/vim-surround" }
    use { "tpope/vim-repeat" }
    use { "terryma/vim-expand-region" }
    use { "terryma/vim-smooth-scroll" }
    use { "mg979/vim-visual-multi" }
    -- use {
    --   "gbprod/substitute.nvim",
    --   event = "BufReadPre",
    --   config = function()
    --     require("config.substitute").setup()
    --   end,
    -- }
    use {
      "abecodes/tabout.nvim",
      opt = true,
      wants = { "nvim-treesitter" },
      after = { "nvim-cmp" },
      config = function()
        require("tabout").setup {
          completion = false,
          ignore_beginning = false,
        }
      end,
    }
    use {
      "nvim-telescope/telescope-live-grep-args.nvim"
    }
    use { "rcarriga/nvim-notify" }
    use {
      "mfussenegger/nvim-treehopper",
      config = function()
        vim.cmd [[omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>]]
        vim.cmd [[vnoremap <silent> m :lua require('tsht').nodes()<CR>]]
      end,
    }
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function() require("config.todocomment").setup {} end
    }
    use {
      "nacro90/numb.nvim"
    }
    use {
      "AckslD/nvim-neoclip.lua",
      config = function()
        require("neoclip").setup({
          keys = {
            telescope = {
              i = {
                select = '<cr>',
                paste = '<c-p>',
                paste_behind = '<c-P>',
                replay = '<c-q>', -- replay a macro
                delete = '<c-d>', -- delete an entry
                custom = {},
              },
              n = {
                select = '<cr>',
                paste = 'p',
                paste_behind = 'P',
                replay = 'q',
                delete = 'd',
                custom = {},
              },
            },
            fzf = {
              select = 'default',
              paste = 'ctrl-p',
              paste_behind = 'ctrl-P',
              custom = {},
            },
          },
        })
      end,
    }
    use {
      "chentoast/marks.nvim",
      event = "BufReadPre",
      config = function()
        require("config.marks").setup()
      end,
    }
    use { 'dhruvasagar/vim-table-mode' }
    use {
      "matbme/JABS.nvim",
      cmd = "JABSOpen",
      config = function()
        require("config.jabs").setup()
      end,
    }
    use {
      "tversteeg/registers.nvim",
      config = function()
        require("config.registers").setup()
      end,
    }
    use {
      'dhruvmanila/telescope-bookmarks.nvim',
      tag = '*',
      -- Uncomment if the selected browser is Firefox, Waterfox or buku
      -- requires = {
      --   'kkharji/sqlite.lua',
      -- }
    }
    use {
      "mrjones2014/legendary.nvim",
      keys = { [[<leader>l]] },
      config = function()
        require("config.legendary").setup()
      end,
      requires = { "stevearc/dressing.nvim" },
    }
    -- use {
    --   'unblevable/quick-scope'
    -- }
    -- use {
    --   'edluffy/hologram.nvim',
    --   config = function()
    --     require('hologram').setup {
    --       auto_display = true -- WIP automatic markdown image display, may be prone to breaking
    --     }
    --   end,
    -- }
    -- Bootstrap Neovim
    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  -- Init and start packer
  packer_init()
  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

return M
