local cmd = vim.cmd

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

require'lspinstall'.setup() -- important

cmd([[
  set wildmode=longest,list,full
  set wildmenu
  
  set wildignore+=**/node_modules/*
  set wildignore+=**/android/*
  set wildignore+=**/ios/*
  set wildignore+=**/.git/*
  set wildignore+=**/.git/*
  
  " LSP mappings
  nnoremap <silen> gd :lua vim .lsp.buf.definition()<CR>
  nnoremap <silent> gD :lua vim .lsp.buf.declaration()<CR>
  nnoremap gr :lua vim .lsp.buf.references()<CR>
  nnoremap <silent> gi :lua vim .lsp.buf.implementation()<CR>
  nnoremap <silent> K :lua vim .lsp.buf.hover()<CR>
  nnoremap <silent> <C-k> :lua vim .lsp.buf.signature_help()<CR>
  nnoremap <silent> <C-p> :lua vim .lsp.diagnostic.goto_prev()<CR>
  nnoremap <silent> <C-n> :lua vim .lsp.diagnostic.goto_next()<CR>
  
  " LSP autoformat
  autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
  autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
  autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 100)
  autocmd BufWritePre *.tsx lua vim.lsp.buf.formatting_sync(nil, 100)
]])
