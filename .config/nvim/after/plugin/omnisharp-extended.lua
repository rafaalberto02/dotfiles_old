local lsp = require("lsp-zero")

lsp.ensure_installed({ 'omnisharp' })

local pid = vim.fn.getpid()

local omnisharp_bin = '/opt/homebrew/bin/omnisharp'

local config = {
    handlers = { ["textDocument/definition"] = require('omnisharp_extended').handler, },
    cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
    enable_editorconfig_support = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    enable_roslyn_analyzers = true,
    analyze_open_documents_only = false,
}

require 'lspconfig'.omnisharp.setup(config)
