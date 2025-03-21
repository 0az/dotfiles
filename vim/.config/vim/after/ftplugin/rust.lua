local bufnr = vim.api.nvim_get_current_buf()

local buf_opts = { buffer = bufnr }
local silent_buf_opts = vim.tbl_extend('error', buf_opts, { silent = true })

-- Action
