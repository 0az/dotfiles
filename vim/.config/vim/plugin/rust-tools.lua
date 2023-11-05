-- Source: https://github.com/simrat39/rust-tools.nvim/blob/71d2cf67b5ed120a0e31b2c8adb210dd2834242f/README.md
-- SPDX-License-Identifier: MIT

local rt = require 'rust-tools'

rt.setup {
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set(
				'n',
				'<Leader>a',
				rt.code_action_group.code_action_group,
				{ buffer = bufnr }
			)
			-- Rename
			vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
			-- Hover
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
		end,
	},
}
