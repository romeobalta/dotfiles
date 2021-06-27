lua require("own.telescope")

nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

nnoremap <leader>tb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>tf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>ts :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ") })<CR>
nnoremap <leader>vrc :lua require('own.telescope').search_dotfiles()<CR>

