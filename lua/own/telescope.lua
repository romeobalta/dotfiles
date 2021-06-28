local cmd = vim.cmd
local api = vim.api

local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    },
    pickers = {
        buffers = {
            theme = "dropdown",
            mappings = {
                i = {
                    ["<c-d>"] = "delete_buffer",
                },
                n = {
                    ["<c-d>"] = "delete_buffer",
                }
            }
        }
    }
}

require('telescope').load_extension('fzy_native')

cmd([[
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

nnoremap <leader>tb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>tf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>ts :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })<CR>
"nnoremap <leader>vrc :lua require('own.telescope').search_dotfiles()<CR>
]])

function own_search_dotfiles()
    require("telescope.builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = "$HOME/dotfiles/",
    })
end

api.nvim_set_keymap('n', '<Leader>vrc', [[:lua own_search_dotfiles()<CR>]], { noremap = true })
