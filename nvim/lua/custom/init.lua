local opt = vim.opt

opt.relativenumber = true

_G.autofmt = function()
	if vim.fn.exists(":RustFmt") > 0 then
		vim.fn["rustfmt#Format"]()
	else
		vim.lsp.buf.format()
	end
end

-- vim.cmd([[autocmd BufWritePre,FileWritePre * lua autofmt()]])

vim.keymap.set({"n", "i", "v"}, "<C-T>", "<Nop>")
