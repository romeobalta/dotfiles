local cmd = vim.cmd

cmd([[
  call wilder#enable_cmdline_enter()
  set wildcharm=<Tab>
  cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
  cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

  " only / and ? are enabled by default
  call wilder#set_option('modes', ['/', '?', ':'])
  
  call wilder#enable_cmdline_enter()
  set wildcharm=<Tab>
  cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
  cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

  " only / and ? are enabled by default
  call wilder#set_option('modes', ['/', '?', ':'])

  " 'highlighter' : applies highlighting to the candidates
  call wilder#set_option('renderer', wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter(), 'left': [ wilder#popupmenu_devicons({ 'get_icoN': wilder#devicons_get_icon_from_nvim_web_devicons() }) ] }))
  "set shortmess+=c
]])
