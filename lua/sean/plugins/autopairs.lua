return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- configure autopairs
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })

    -- import nvim-autopairs completion functionality
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- import nvim-cmp plugin (completions plugin)
    local cmp = require("cmp")

    -- make autopairs and completion work together
    -- Avoid adding parentheses on confirm in JSX/TSX where React components
    -- should expand to tags instead of function calls.
    local handlers = require("nvim-autopairs.completion.handlers")
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done({
        filetypes = {
          ["*"] = {
            ["("] = {
              kind = {
                cmp.lsp.CompletionItemKind.Function,
                cmp.lsp.CompletionItemKind.Method,
              },
              handler = handlers["("],
            },
          },
          -- Disable adding `()` for React TSX/JSX filetypes
          typescriptreact = { ["("] = false },
          javascriptreact = { ["("] = false },
        },
      })
    )
  end,
}

