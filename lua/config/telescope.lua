local M = {}
-- Custom actions
local transform_mod = require("telescope.actions.mt").transform_mod
local nvb_actions = transform_mod {
  file_path = function(prompt_bufnr)
    -- Get selected entry and the file full path
    local content = require("telescope.actions.state").get_selected_entry()
    local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

    -- Yank the path to unnamed register
    vim.fn.setreg('"', full_path)

    -- Close the popup
    require("utils").info "File path is yanked "
    require("telescope.actions").close(prompt_bufnr)
  end,
  -- VisiData
  visidata = function(prompt_bufnr)
    -- Get the full path
    local content = require("telescope.actions.state").get_selected_entry()
    local full_path = content.cwd .. require("plenary.path").path.sep .. content.value

    -- Close the Telescope window
    require("telescope.actions").close(prompt_bufnr)

    -- Open the file with VisiData
    local term = require "utils.term"
    term.open_term("vd " .. full_path, { direction = "float" })
  end,
}
function M.setup()
  local actions = require "telescope.actions"
  local telescope = require "telescope"
  -- Custom previewer
  local previewers = require "telescope.previewers"
  local Job = require "plenary.job"
  local lga_actions = require("telescope-live-grep-args.actions")
  local preview_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job
        :new({
          command = "file",
          args = { "--mime-type", "-b", filepath },
          on_exit = function(j)
            local is_image = function(path)
              local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
              local split_path = vim.split(path:lower(), ".", { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
              print("path is " .. filepath)
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _)
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d .. "\r\n")
                end
              end

              vim.fn.jobstart({
                "viu",
                filepath,
              }, {
                on_stdout = send_output,
                stdout_buffered = true,
              })
            else
              local mime_type = vim.split(j:result()[1], "/")[1]

              if mime_type == "text" then
                -- Check file size
                vim.loop.fs_stat(filepath, function(_, stat)
                  if not stat then
                    return
                  end
                  if stat.size > 500000 then
                    return
                  else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                  end
                end)
              else
                vim.schedule(function()
                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY FILE" })
                end)
              end
            end
          end,
        })
        :sync()
  end

  telescope.setup {
    defaults = {
      -- layout_strategies = 'vertical',
      theme = "dropdown",
      layout_config = {
        width = 0.8,
        height = 0.5,
      },
      preview = {
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function(filepath)
            local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
            local split_path = vim.split(filepath:lower(), ".", { plain = true })
            local extension = split_path[#split_path]
            return vim.tbl_contains(image_extensions, extension)
          end
          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d .. "\r\n")
              end
            end

            vim.fn.jobstart({
              "viu",
              -- "-w",
              -- "40",
              "-b",
              filepath,
            }, {
              on_stdout = send_output,
              stdout_buffered = true,
            })
          else
            require("telescope.previewers.utils").set_preview_message(
              bufnr,
              opts.winid,
              "Binary cannot be previewed"
            )
          end
        end,
      },
      -- buffer_previewer_maker = preview_maker,
      mappings = {
        i = {
          ["<ESC>]{0}j"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
        },
      },
      path_display = {
        shorten = {
          len = 1,
          exclude = { 1, -1, -2 }
        },
      },
    },
    pickers = {
      grep_string = {
        -- theme = "ivy",
        theme = "dropdown",
        -- layout_strategies = 'vertical',
        layout_config = {
          width = 0.8,
        },
        mappings = {
          n = {
            ["y"] = nvb_actions.file_path,
          },
          i = {
            ["<C-y>"] = nvb_actions.file_path,
          },
        },
      },
      live_grep = {
        theme = "dropdown",
        -- layout_strategies = 'vertical',
        layout_config = {
          width = 0.8,
          height = 0.5,
        },
        mappings = {
          n = {
            ["y"] = nvb_actions.file_path,
          },
          i = {
            ["<C-y>"] = nvb_actions.file_path,
          },
        },
      },
      find_files = {
        theme = "dropdown",
        -- layout_strategies = 'vertical',
        layout_config = {
          width = 0.8,
          height = 0.5,
        },
        mappings = {
          n = {
            ["y"] = nvb_actions.file_path,
            ["s"] = nvb_actions.visidata,
          },
          i = {
            ["<C-y>"] = nvb_actions.file_path,
            ["<C-s>"] = nvb_actions.visidata,
          },
        },
      },
      git_files = {
        theme = "dropdown",
        mappings = {
          n = {
            ["y"] = nvb_actions.file_path,
            ["s"] = nvb_actions.visidata,
          },
          i = {
            ["<C-y>"] = nvb_actions.file_path,
            ["<C-s>"] = nvb_actions.visidata,
          },
        },
      },
      oldfiles = {
        theme = "dropdown",
        -- layout_strategies = 'vertical',
        layout_config = {
          width = 0.8,
          height = 0.5,
        },
      },

    },
    extensions = {
      notify = {
        theme = "dropdown",
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.8,
          height = 0.5,
        },
      },
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        default_mappings = {
          i = {
            ["<C-]>"] = lga_actions.quote_prompt(),
          }
        }
      },
      bookmarks = {
        -- Available:
        --  * 'brave'
        --  * 'buku'
        --  * 'chrome'
        --  * 'chrome_beta'
        --  * 'edge'
        --  * 'firefox'
        --  * 'qutebrowser'
        --  * 'safari'
        --  * 'vivaldi'
        --  * 'waterfox'
        selected_browser = 'chrome',

        -- Either provide a shell command to open the URL
        url_open_command = 'open',

        -- Or provide the plugin name which is already installed
        -- Available: 'vim_external', 'open_browser'
        url_open_plugin = nil,

        -- Show the full path to the bookmark instead of just the bookmark name
        full_path = true,

        -- Provide a custom profile name for Firefox browser
        firefox_profile_name = nil,

        -- Provide a custom profile name for Waterfox browser
        waterfox_profile_name = nil,

        -- Add a column which contains the tags for each bookmark for buku
        buku_include_tags = false,

        -- Provide debug messages
        debug = false,
      },
    }
  }

  telescope.load_extension "fzf"
  telescope.load_extension "project" -- telescope-project.nvim
  telescope.load_extension "repo"
  telescope.load_extension "file_browser"
  telescope.load_extension "projects" -- project.nvim
  telescope.load_extension "neoclip"
  telescope.load_extension "bookmarks"
  telescope.load_extension 'media_files'
  telescope.load_extension 'live_grep_args'
  require("telescope").load_extension("notify")

  -- local builtin = require "telescope.builtin"
  -- builtin.grep_string{
  --   path_display = { "shorten","absolute", }
  -- }
  -- builtin.find_files{
  --   path_display = { "shorten","absolute",}
  -- }
end

M.switch_projects = function()
  require("telescope.builtin").find_files({
    prompt_title = "< Switch Project >",
    cwd = "$HOME/Documents/ideaProjects/",
  })
end
return M
