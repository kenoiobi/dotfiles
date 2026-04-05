return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "ts_ls",
                    "eslint",
                    "tailwindcss",
                    "gopls",
                    "rust_analyzer",
                    "marksman",
                },
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- Formatters
                    "prettier",
                    "stylua",
                    "goimports",
                    "gofumpt",
                    "ruff",
                    "sqlfmt",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Python
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })

            -- TypeScript / JavaScript / React / Next.js
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                        },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                        suggest = {
                            completeFunctionCalls = true,
                        },
                    },
                },
            })

            -- ESLint
            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll",
                    })
                end,
            })

            -- Tailwind CSS (useful for Next.js / React projects with Tailwind)
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
            })

            -- Go
            lspconfig.gopls.setup({
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            -- Rust
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                        },
                        cargo = {
                            allFeatures = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                    },
                },
            })

            -- Markdown (diagnostics, link following, toc)
            lspconfig.marksman.setup({
                capabilities = capabilities,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
                    end

                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gr", vim.lsp.buf.references, "Go to references")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("K", vim.lsp.buf.hover, "Hover documentation")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
                    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                end,
            })
        end,
    },
}
