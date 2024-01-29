local bufnr = vim.api.nvim_get_current_buf()

local buf_opts = { buffer = bufnr }
local silent_buf_opts = vim.tbl_extend('error', buf_opts, { silent = true })

-- Action
vim.keymap.set('n', '<leader>a', function()
	vim.cmd.RustLsp 'codeAction' -- supports rust-analyzer's grouping
	-- or vim.lsp.buf.codeAction() if you don't want grouping.
end, silent_buf_opts)
