set completeopt=menuone,noselect

set wildmode=longest,list,full
set wildmenu

set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*
set wildignore+=**/.git/*

set shortmess+=c

" LSP mappings
nnoremap <silent> gd :lua vim .lsp.buf.definition()<CR>
nnoremap <silent> gD :lua vim .lsp.buf.declaration()<CR>
nnoremap <silent> gr :lua vim .lsp.buf.references()<CR>
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

lua require("own.lsp")
