local M = {}

local nls = require "null-ls"
local nls_utils = require "null-ls.utils"
local b = nls.builtins
local command_resolver = require "null-ls.helpers.command_resolver"

local with_diagnostics_code = function(builtin)
	return builtin.with {
		diagnostics_format = "#{m} [#{c}]",
	}
end

local with_root_file = function(builtin, file)
	return builtin.with {
		condition = function(utils)
			return utils.root_has_file(file)
		end,
	}
end

local sources = {
	-- formatting
	b.formatting.prettierd.with { dynamic_command = command_resolver.from_node_modules() },
	b.formatting.shfmt,
	b.formatting.fixjson,
	b.formatting.black.with { extra_args = { "--fast" } },
	b.formatting.isort,
	-- b.formatting.google_java_format,
	-- with_root_file(b.formatting.stylua, "stylua.toml"),

	-- diagnostics
	-- b.diagnostics.write_good,
	-- b.diagnostics.markdownlint,
	-- b.diagnostics.eslint_d,
	-- b.diagnostics.flake8,
	-- b.diagnostics.tsc,
	with_root_file(b.diagnostics.selene, "selene.toml"),
	with_diagnostics_code(b.diagnostics.shellcheck),

	-- code actions
	-- b.code_actions.gitsigns,
	b.code_actions.gitrebase,

	-- hover
	b.hover.dictionary,
}

function M.setup(opts)
	nls.setup {
		-- debug = true,
		debounce = 150,
		save_after_format = true,
		sources = sources,
		on_attach = opts.on_attach,
		root_dir = nls_utils.root_pattern ".git",
	}
end

return M
