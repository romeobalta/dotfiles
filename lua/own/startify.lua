local g = vim.g
local fn = vim.fn
local cmd = vim.cmd

cmd([=[
  let g:startify_session_dir = $HOME . '/.config/nvim/sessions'
  
  let g:startify_session_persistence = 1
  "let g:startify_session_delete_buffers = 1
  let g:startify_enable_special = 0
  let g:startify_change_to_vcs_root = 1
  let g:startify_session_autoload = 1

  augroup nerd_tree_own
    au!
    "au SessionLoadpost * NvimTreeOpen
  augroup END
]=])

g.startify_lists = {
  { type = 'sessions',    header = { '   Sessions'  } },
  { type = 'dir',         header = { '   '..fn.getcwd()  } },
  { type = 'bookmarks',   header = { '   Bookmarks'  } },
  { type = 'files',       header = { '   Files'  } },
}

g.startify_session_before_save = { 'silent! NvimTreeClose' }
g.startify_session_delete_buffers = 1
