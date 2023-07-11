-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    local mappings = {
        -- BEGIN_DEFAULT_ON_ATTACH
        ["<C-]>"] = { api.tree.change_root_to_node, "CD" },
        ["<C-e>"] = { api.node.open.replace_tree_buffer, "Open: In Place" },
        ["<C-k>"] = { api.node.show_info_popup, "Info" },
        ["<C-r>"] = { api.fs.rename_sub, "Rename: Omit Filename" },
        ["<C-t>"] = { api.node.open.tab, "Open: New Tab" },
        ["<C-v>"] = { api.node.open.vertical, "Open: Vertical Split" },
        ["<C-x>"] = { api.node.open.horizontal, "Open: Horizontal Split" },
        ["<BS>"] = { api.node.navigate.parent_close, "Close Directory" },
        ["<CR>"] = { api.node.open.edit, "Open" },
        ["<Tab>"] = { api.node.open.preview, "Open Preview" },
        [">"] = { api.node.navigate.sibling.next, "Next Sibling" },
        ["<"] = { api.node.navigate.sibling.prev, "Previous Sibling" },
        ["."] = { api.node.run.cmd, "Run Command" },
        ["-"] = { api.tree.change_root_to_parent, "Up" },
        ["a"] = { api.fs.create, "Create" },
        ["bmv"] = { api.marks.bulk.move, "Move Bookmarked" },
        ["B"] = { api.tree.toggle_no_buffer_filter, "Toggle No Buffer" },
        ["c"] = { api.fs.copy.node, "Copy" },
        ["C"] = { api.tree.toggle_git_clean_filter, "Toggle Git Clean" },
        ["[c"] = { api.node.navigate.git.prev, "Prev Git" },
        ["]c"] = { api.node.navigate.git.next, "Next Git" },
        ["d"] = { api.fs.remove, "Delete" },
        ["D"] = { api.fs.trash, "Trash" },
        ["E"] = { api.tree.expand_all, "Expand All" },
        ["e"] = { api.fs.rename_basename, "Rename: Basename" },
        ["]e"] = { api.node.navigate.diagnostics.next, "Next Diagnostic" },
        ["[e"] = { api.node.navigate.diagnostics.prev, "Prev Diagnostic" },
        ["F"] = { api.live_filter.clear, "Clean Filter" },
        ["f"] = { api.live_filter.start, "Filter" },
        ["g?"] = { api.tree.toggle_help, "Help" },
        ["gy"] = { api.fs.copy.absolute_path, "Copy Absolute Path" },
        ["H"] = { api.tree.toggle_hidden_filter, "Toggle Dotfiles" },
        ["I"] = { api.tree.toggle_gitignore_filter, "Toggle Git Ignore" },
        ["J"] = { api.node.navigate.sibling.last, "Last Sibling" },
        ["K"] = { api.node.navigate.sibling.first, "First Sibling" },
        ["m"] = { api.marks.toggle, "Toggle Bookmark" },
        ["o"] = { api.node.open.edit, "Open" },
        ["O"] = { api.node.open.no_window_picker, "Open: No Window Picker" },
        ["p"] = { api.fs.paste, "Paste" },
        ["P"] = { api.node.navigate.parent, "Parent Directory" },
        ["q"] = { api.tree.close, "Close" },
        ["r"] = { api.fs.rename, "Rename" },
        ["R"] = { api.tree.reload, "Refresh" },
        ["s"] = { api.node.run.system, "Run System" },
        ["S"] = { api.tree.search_node, "Search" },
        ["U"] = { api.tree.toggle_custom_filter, "Toggle Hidden" },
        ["W"] = { api.tree.collapse_all, "Collapse" },
        ["x"] = { api.fs.cut, "Cut" },
        ["y"] = { api.fs.copy.filename, "Copy Name" },
        ["Y"] = { api.fs.copy.relative_path, "Copy Relative Path" },
        ["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
        ["<2-RightMouse>"] = { api.tree.change_root_to_node, "CD" },
        -- END_DEFAULT_ON_ATTACH

        -- Mappings migrated from view.mappings.list
        ["l"] = { api.node.open.edit, "Open" },
        ["<CR>"] = { api.node.open.edit, "Open" },
        ["o"] = { api.node.open.edit, "Open" },
        ["h"] = { api.node.navigate.parent_close, "Close Directory" },
        ["v"] = { api.node.open.vertical, "Open: Vertical Split" },
        ["C"] = { api.tree.change_root_to_node, "CD" },
    }

  for keys, mapping in pairs(mappings) do
      vim.keymap.set("n", keys, mapping[1], opts(mapping[2]))
  end

  local tree_actions = {
      {
          name = "Create node",
          handler = require("nvim-tree.api").fs.create,
      },
      {
          name = "Remove node",
          handler = require("nvim-tree.api").fs.remove,
      },
      {
          name = "Trash node",
          handler = require("nvim-tree.api").fs.trash,
      },
      {
          name = "Rename node",
          handler = require("nvim-tree.api").fs.rename,
      },
      {
          name = "Fully rename node",
          handler = require("nvim-tree.api").fs.rename_sub,
      },
      {
          name = "Copy",
          handler = require("nvim-tree.api").fs.copy.node,
      }
  }

  local function tree_actions_menu(node)
      local entry_maker = function(menu_item)
          return {
              value = menu_item,
              ordinal = menu_item.name,
              display = menu_item.name,
          }
      end

      local finder = require("telescope.finders").new_table({
          results = tree_actions,
          entry_maker = entry_maker,
      })

      local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

      local default_options = {
          finder = finder,
          sorter = sorter,
          attach_mappings = function(prompt_buffer_number)
              local actions = require("telescope.actions")

              -- On item select
              actions.select_default:replace(function()
                  local state = require("telescope.actions.state")
                  local selection = state.get_selected_entry()
                  -- Closing the picker
                  actions.close(prompt_buffer_number)
                  -- Executing the callback
                  selection.value.handler(node)
              end)

              -- The following actions are disabled in this example
              -- You may want to map them too depending on your needs though
              actions.add_selection:replace(function() end)
              actions.remove_selection:replace(function() end)
              actions.toggle_selection:replace(function() end)
              actions.select_all:replace(function() end)
              actions.drop_all:replace(function() end)
              actions.toggle_all:replace(function() end)

              return true
          end,
      }

      -- Opening the menu
      require("telescope.pickers").new({ prompt_title = "Tree menu" }, default_options):find()
  end

  vim.keymap.set("n", "<C-Space>", tree_actions_menu, { buffer = bufnr, noremap = true, silent = true })
end

-- pass to setup along with your other options
require("nvim-tree").setup {
    ---
    on_attach = my_on_attach,
    ---
}

local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- create a new, empty buffer
  vim.cmd.enew()

  -- wipe the directory buffer
  vim.cmd.bw(data.buf)

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
