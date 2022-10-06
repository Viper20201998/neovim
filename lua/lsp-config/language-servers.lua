local lsp_installer = require("nvim-lsp-installer")


local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


local servers = {
    "bashls",
    "cssls",
    "emmet_ls",
    "ltex",
    "sumneko_lua",
    "tsserver",
}

---@diagnostic disable-next-line: undefined-global
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lsp_flags = {
    debounce_text_changes = 150,
}

require('lspconfig')['html'].setup { on_attach = on_attach, capabilities = capabilities, flags = lsp_flags, }
require('lspconfig')['cssls'].setup { on_attach = on_attach, capabilities = capabilities, flags = lsp_flags, }
require('lspconfig')['cssmodules_ls'].setup { on_attach = on_attach, capabilities = capabilities, flags = lsp_flags, }
require('lspconfig')['tsserver'].setup { on_attach = on_attach, capabilities = capabilities, flags = lsp_flags, }
require('lspconfig')['pyright'].setup { on_attach = on_attach, capabilities = capabilities, flags = lsp_flags, }


for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found then
        if not server:is_installed() then
            print("Installing " .. name)
            server:install()
        end
    end
end

lsp_installer.on_server_ready(function(server)
    local default_opts = {
        on_attach = on_attach,
    }

    local server_opts = {
        ["eslintls"] = function()
            default_opts.settings = {
                format = {
                    enable = true,
                },
            }
        end,
    }

    local server_options = server_opts[server.name] and server_opts[server.name]() or default_opts
    server:setup(server_options)
end)
