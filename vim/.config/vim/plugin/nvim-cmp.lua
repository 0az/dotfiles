-- Source: https://github.com/hrsh7th/nvim-cmp/blob/feed47fd1da7a1bad2c7dca456ea19c8a5a9823a/README.md
-- SPDX-License-Identifier: MIT

-- Set up nvim-cmp.
local cmp = try_require 'cmp'
if not cmp then
	return
end

local has_ultisnips = vim.g.did_plugin_ultisnips == 1

local cmp_ultisnips_mappings = try_require 'cmp_nvim_ultisnips.mappings'

local cmp_mapping = {
	['<C-b>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.abort(),
	['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}

if has_ultisnips and cmp_ultisnips_mappings then
	cmp_mapping = vim.tbl_extend('force', cmp_mapping, {
		['<Tab>'] = cmp.mapping(function(fallback)
			cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
		end, {
			'i',
			's', --[[ "c" (to enable the mapping in command mode) ]]
		}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			cmp_ultisnips_mappings.jump_backwards(fallback)
		end, {
			'i',
			's', --[[ "c" (to enable the mapping in command mode) ]]
		}),
	})
end

local cmp_sources_default_group = {
	{ name = 'nvim_lsp' },
	-- { name = 'vsnip' }, -- For vsnip users.
	-- { name = 'luasnip' }, -- For luasnip users.
	-- { name = 'ultisnips' }, -- For ultisnips users.
	-- { name = 'snippy' }, -- For snippy users.
}
if has_ultisnips then
	table.insert(cmp_sources_default_group, { name = 'ultisnips' })
end

local cmp_sources = cmp.config.sources(cmp_sources_default_group, { { name = 'buffer' } })

cmp.setup {
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.

			if has_ultisnips then
				vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
			else
				vim.snippet.expand(args.body)
			end
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert(cmp_mapping),
	sources = cmp_sources,
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources(
		{ { name = 'cmp_git' } },
		{ { name = 'buffer' } }
	),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

-- Set up lspconfig.
local cmp_nvim_lsp = try_require 'cmp_nvim_lsp'
if cmp_nvim_lsp then
	capabilities = cmp_nvim_lsp.default_capabilities()
end

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }
