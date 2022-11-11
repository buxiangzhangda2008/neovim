local M = {}

function M.setup()
  require("nvim-tree").setup {

    disable_netrw = true,
    hijack_netrw = true,
    sort_by = "case_sensitive",
    view = {
      number = false,
      relativenumber = false,
      adaptive_size = true,
      mappings = {
        custom_only = true,
        list = {
          {
            key = { "<CR>", "o", "<2-LeftMouse>" },
            action = "edit",
            desc = "open a file or folder; root will cd to the above directory",
          },
          {
            key = "<C-e>",
            action = "edit_in_place",
            desc = "edit the file in place, effectively replacing the tree explorer",
          },
          {
            key = "O",
            action = "edit_no_picker",
            desc = "same as (edit) with no window picker",
          },
          {
            key = { "<C-]>", "<2-RightMouse>" },
            action = "cd",
            desc = "cd in the directory under the cursor",
          },
          {
            key = "gvs",
            action = "vsplit",
            desc = "open the file in a vertical split",
          },
          {
            key = "gs",
            action = "split",
            desc = "open the file in a horizontal split",
          },
          {
            key = "<C-t>",
            action = "tabnew",
            desc = "open the file in a new tab",
          },
          {
            key = "<",
            action = "prev_sibling",
            desc = "navigate to the previous sibling of current file/directory",
          },
          {
            key = ">",
            action = "next_sibling",
            desc = "navigate to the next sibling of current file/directory",
          },
          {
            key = "P",
            action = "parent_node",
            desc = "move cursor to the parent directory",
          },
          {
            key = "<BS>",
            action = "close_node",
            desc = "close current opened directory or parent",
          },
          {
            key = "go",
            action = "preview",
            desc = "open the file as a preview (keeps the cursor in the tree)",
          },
          {
            key = "K",
            action = "first_sibling",
            desc = "navigate to the first sibling of current file/directory",
          },
          {
            key = "J",
            action = "last_sibling",
            desc = "navigate to the last sibling of current file/directory",
          },
          {
            key = "H",
            action = "toggle_git_ignored",
            desc = "toggle visibility of files/folders hidden via |git.ignore| option",
          },
          {
            key = "I",
            action = "toggle_dotfiles",
            desc = "toggle visibility of dotfiles via |filters.dotfiles| option",
          },
          {
            key = "U",
            action = "toggle_custom",
            desc = "toggle visibility of files/folders hidden via |filters.custom| option",
          },
          {
            key = "R",
            action = "refresh",
            desc = "refresh the tree",
          },
          {
            key = "a",
            action = "create",
            desc = "add a file; leaving a trailing `/` will add a directory",
          },
          {
            key = "d",
            action = "remove",
            desc = "delete a file (will prompt for confirmation)",
          },
          {
            key = "D",
            action = "trash",
            desc = "trash a file via |trash| option",
          },
          {
            key = "r",
            action = "rename",
            desc = "rename a file",
          },
          {
            key = "<C-r>",
            action = "full_rename",
            desc = "rename a file and omit the filename on input",
          },
          {
            key = "x",
            action = "cut",
            desc = "add/remove file/directory to cut clipboard",
          },
          {
            key = "c",
            action = "copy",
            desc = "add/remove file/directory to copy clipboard",
          },
          {
            key = "p",
            action = "paste",
            desc = "paste from clipboard; cut clipboard has precedence over copy; will prompt for confirmation",
          },
          {
            key = "y",
            action = "copy_name",
            desc = "copy name to system clipboard",
          },
          {
            key = "Y",
            action = "copy_path",
            desc = "copy relative path to system clipboard",
          },
          {
            key = "gy",
            action = "copy_absolute_path",
            desc = "copy absolute path to system clipboard",
          },
          {
            key = "[c",
            action = "prev_git_item",
            desc = "go to next git item",
          },
          {
            key = "]c",
            action = "next_git_item",
            desc = "go to prev git item",
          },
          {
            key = "u",
            action = "dir_up",
            desc = "navigate up to the parent directory of the current file/directory",
          },
          {
            key = "s",
            action = "system_open",
            desc = "open a file with default system application or a folder with default file manager, using |system_open| option",
          },
          {
            key = "f",
            action = "live_filter",
            desc = "live filter nodes dynamically based on regex matching.",
          },
          {
            key = "F",
            action = "clear_live_filter",
            desc = "clear live filter",
          },
          {
            key = "q",
            action = "close",
            desc = "close tree window",
          },
          {
            key = "W",
            action = "collapse_all",
            desc = "collapse the whole tree",
          },
          {
            key = "E",
            action = "expand_all",
            desc = "expand the whole tree, stopping after expanding |actions.expand_all.max_folder_discovery| folders; this might hang neovim for a while if running on a big folder",
          },
          {
            key = "S",
            action = "search_node",
            desc = "prompt the user to enter a path and then expands the tree to match the path",
          },
          {
            key = ".",
            action = "run_file_command",
            desc = "enter vim command mode with the file the cursor is on",
          },
          {
            key = "<C-k>",
            action = "toggle_file_info",
            desc = "toggle a popup with file infos about the file under the cursor",
          },
          {
            key = "?",
            action = "toggle_help",
            desc = "toggle help",
          },

        },
      },
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
      -- custom = { ".git" },
    },
    update_cwd = true,
    update_focused_file = {
      enable = false,
      update_cwd = true,
    },
  }

  vim.g.nvim_tree_respect_buf_cwd = 1
end

return M
