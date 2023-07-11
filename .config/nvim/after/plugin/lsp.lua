local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'angularls',
    'bashls',
    'clangd',
    'cssls',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'html',
    'lua_ls',
    'marksman',
    'pylsp',
    'sqlls',
    'tsserver'
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_config = require('lspconfig')

lsp_config.angularls.setup{}
lsp_config.bashls.setup{}
lsp_config.clangd.setup{}
lsp_config.cssls.setup{}
lsp_config.cssls.setup {  capabilities = capabilities, }
lsp_config.docker_compose_language_service.setup{}
lsp_config.dockerls.setup{}
lsp_config.eslint.setup{}
lsp_config.html.setup {  capabilities = capabilities, }
lsp_config.jsonls.setup {  capabilities = capabilities, }
lsp_config.lua_ls.setup{}
lsp_config.marksman.setup{}
lsp_config.pylsp.setup{}
lsp_config.sqlls.setup{}
lsp_config.tsserver.setup{}

-- Fix Undefined global 'vim'
lsp.nvim_workspace()



lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})


lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.setup()

local cmp_action = lsp.cmp_action()

cmp.setup({
  mapping = {
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts) 
  end
})

require('mason').setup()
require('mason-lspconfig').setup()


vim.diagnostic.config({
    virtual_text = true
})


