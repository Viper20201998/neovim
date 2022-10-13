local null_ls = require('null-ls')

local formatting = null_ls.builtins.formatting

local sources = {
    formatting.autopep8,
    formatting.stylua.with({
        extra_args = { "--config-path", vim.fn.expand("~/.config/nvim/lua/formating-conf/stylua.toml") },
    }),
}

null_ls.setup({
    sources = sources,
    on_attach = function(client)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.format()
                end,
            })
        end
    end,
})
