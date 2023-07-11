-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"
    api.config.mappings.default_on_attach(bufnr)

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
    renderer = {
        indent_markers = {
            enable = true,
            icons = {
                corner = "└ ",
                edge = "│ ",
                item = "│ ",
                none = "  ",
            },
        },
        icons = {
            webdev_colors = true,
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true
            },
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "", -- 
                    staged = "",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
    },
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
